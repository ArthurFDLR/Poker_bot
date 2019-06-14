--------------------------------------------------------------------------
-- Utiliser le script python simulant le Launcher pour utiliser ce test --
--------------------------------------------------------------------------

WITH ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;
USE  ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;

procedure test_MaJ_Bot is 
   i : Integer := 0;
   message_tmp : T_message;
   
   -- Simulation partie
   Table : T_liste_cartes;
   info_partie : T_Jeu;
   J_Self,J_Other : T_joueur;
   
begin
   -- Serie de commandes passees par le script python :
   Get(i);
   Skip_Line;
   for j in 1..i LOOP
      get(message_tmp);
      Update_data(message     => message_tmp,
                  Table       => Table,
                  info_partie => info_partie,
                  J_Self      => J_Self,
                  J_Other     => J_Other);
   end loop;
   
   -- Affichage de l'etat en fin de MaJ :

   Put_Line(" - ETAT DE LA PARTIE :");
   Affiche_jeu(info_partie);
   
   Put_Line(" - ETAT DE LA TABLE :");
   Affiche_liste_carte(Table);
   
   Put_Line(" - ETAT DE SELF :");
   Affiche_joueur(J_Self);
   
   Put_Line(" - ETAT DE OTHER :");
   Affiche_joueur(J_Other);
   
end test_MaJ_Bot;
