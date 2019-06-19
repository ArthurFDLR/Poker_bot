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
      Update_data(message     => message,
                  Table       => Table,
                  info_partie => info_partie,
                  J_Self      => Self,
                  J_Other     => Other);

      if Get_Action_needed(info_partie) THEN -- Si le launcher attend une réponse

         Jouer(move        => call,
               Amount_move => 0,
               Self        => Self,
               Other       => Other);

         Set_Action_needed(info_partie, False);
      end if;
   end loop;
end;
