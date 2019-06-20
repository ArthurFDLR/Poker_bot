--------------------------------------------------------------------------
-- Utiliser le script python simulant le Launcher pour utiliser ce test --
--------------------------------------------------------------------------

WITH ada.Command_Line, ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes, Evaluation_main, Ada.Calendar;
USE  ada.Command_Line, ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes, Evaluation_main, Ada.Calendar;

procedure Test_comparaison_algo is
   info_partie : T_Jeu;
   Self,Other : T_joueur;
   Table : T_liste_cartes;
   
   i : Integer := 0;
   message_tmp : T_message;
   
   temps : time;
   duree_1 : Duration;
   res_gagne_1 : Integer;
   
   function Argument_to_Message(Index : IN Integer) return T_message is
      message_str : String(1..Argument(Index)'Last);
      message_chaine : T_chaine;
      message : T_message;
   Begin
      for i in 1..Argument(Index)'Last LOOP
         if Argument(Index)(i) = ';' THEN
            message_str(i) := ' ';
         else
            message_str(i) := Argument(Index)(i);
         end if;
      end LOOP; 
      Set_chaine(Chaine      => message_chaine,
                 line        => message_str,
                 line_length => Argument(Index)'Last);
      Set_message(Message => message,
                  Chaine  => message_chaine);
      --lecture_update_hand(message, Table, info_partie, Self, Other);
      return message;
   end;
   
begin
   message_tmp := Argument_to_Message(1);
   Update_data(message     => message_tmp,
               Table       => Table,
               info_partie => info_partie,
               J_Self      => Self,
               J_Other     => Other);
     
   message_tmp := Argument_to_Message(2);
   Update_data(message     => message_tmp,
               Table       => Table,
               info_partie => info_partie,
               J_Self      => Self,
               J_Other     => Other);
   
   temps := Clock;
   res_gagne_1 := pourcentage_gagne_PostFlop_TimeLimited(Table        => Table,
                                                         Self         => Self,
                                                         Limite_duree => 2.0);
   duree_1 := Clock - temps;

   Put_Line(Natural'Image(res_gagne_1) & ";" & Duration'Image(duree_1));
   
end Test_comparaison_algo;
