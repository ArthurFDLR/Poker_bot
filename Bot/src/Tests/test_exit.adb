With ada.Text_IO, Ada.Calendar;
Use  ada.Text_IO, Ada.Calendar;

procedure test_exit is
   i : Integer := 0;
   temps_init : Time;
   loop_int : integer := 100;
   
   function test(i : IN Integer) return Boolean is
   Begin
      Return True;
   end;
   
begin
   temps_init := Clock;
   
   calcul_cycle:
   for j in 1..loop_int LOOP
      for k in 1..loop_int LOOP
         for l in 1..loop_int LOOP
            i := i+1;
            exit calcul_cycle when (Float(Clock-temps_init)>0.05);
         end LOOP;
      end LOOP;
   end LOOP calcul_cycle;

   if test(4) THEN
      Put_Line("Yay");
   End if;
   
            
   Put_Line(Integer'Image(i));
end test_exit;
