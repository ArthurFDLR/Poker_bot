WITH ada.text_io, Modelisation_poker, lecture_messages, Analyse_cartes;
USE  ada.text_io, Modelisation_poker, lecture_messages, Analyse_cartes;

procedure bot is

   message : T_message;
   info_partie : T_jeu;
   Self : T_joueur;
   Other : T_joueur;
   Table : T_liste_cartes;

begin
   while not End_Of_File loop   -- Loop infini de jeu

      Get(message);

      if Get_chaine_line(Get_message_mot(message,1)) = "action" THEN
         Put_Line("fold");
      else
         Update_data(message     => message,
                     Table       => Table,
                     info_partie => info_partie,
                     J_Self      => Self,
                     J_Other     => Other);
      end if;
   end loop;
end;
