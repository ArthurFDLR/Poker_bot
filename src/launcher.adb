with Ada.Text_IO;
use Ada.Text_IO;
with GNAT.OS_Lib;
use GNAT.OS_Lib;
with Ada.Numerics.Discrete_Random;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;

procedure Launcher is
   Java : constant String := "C:\Users\ArthF\Documents\ENSMA\PROJET_INFO_S2\Bot_encaps\jdk-11.0.1\bin\java";
   Engine : constant String := "lib/engine.jar";
   Ref_Name : constant String := "Javabot";
   Ref_Bot : constant String := "lib/bot.jar";
   Ada_Name : constant String := "Adabot";
   Ada_Bot : constant String := "obj/bot";
   Result    : Boolean;
   Arguments : Argument_List :=
     (
      1 => new String'("-jar"),
      2 => new String'(Engine),
      3 => new String'(Ref_Name),
      4 => new String'(Java & " -jar " & Ref_Bot),
      5 => new String'(Ada_Name),
      6 => new String'(Ada_Bot),
      7 => null
     );
   package Rand_Int is new Ada.Numerics.Discrete_Random(Positive);
   seed : Integer;
   generator : Rand_Int.Generator;
   seedStr : String_Access;
begin
   -- Get a random number as a seed for the engine
   Put_Line("Launching...");
   Rand_Int.Reset(generator);
   seed := Rand_Int.Random(generator);
   seedStr := new String'(Trim(Positive'Image(seed), Ada.Strings.Left));
   Arguments(7) := seedStr;
   Spawn(
      Program_Name       => Java,
      Args               => Arguments,
      Success            => Result
   );
   if (not Result) then
      Put_Line("Engine execution failed: please check your configuration.");
   end if;
end Launcher;
