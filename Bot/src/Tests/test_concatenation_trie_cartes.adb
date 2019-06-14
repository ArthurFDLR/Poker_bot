WITH ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;
USE  ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;

procedure test_concatenation_trie_cartes is
   info_partie : T_Jeu;
   Self : T_joueur;
   Other : T_joueur;
   message_test : T_message;
   Table : T_liste_cartes;
   cartes_concat : T_liste_cartes;
begin
   --Definir etat de table et main du joueur
   
   Get(message_test); -- "update_hand table 4s,Td,Ts,3c,5d"
   Update_data(message_test, Table, info_partie, Self, Other);
   
   Get(message_test); -- "update_hand hand self Qd,Tc"
   Update_data(message_test, Table, info_partie, Self, Other);
  
   Put_Line("Cartes du joueur :");
   Affiche_liste_carte(liste_carte => Get_joueur_main(Self));

   Put_Line("Cartes sur la table :");
   Affiche_liste_carte(Table);
   -- Concatenation de table et des cartes du joueru :
   
   cartes_concat := concatenation_cartes(Self , table);

   Put_Line("Cartes dans la concatenation :");
   Affiche_liste_carte(cartes_concat);
   
   trier_cartes(cartes_concat);
   
   Put_Line("Cartes apres triage :");
   Affiche_liste_carte(cartes_concat);
   
end test_concatenation_trie_cartes;
