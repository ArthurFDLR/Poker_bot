WITH ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes, Evaluation_main;
USE  ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes, Evaluation_main;

procedure test_analyse_main is
   info_partie : T_Jeu;
   Self : T_joueur;
   Other : T_joueur;
   message_test : T_message;
   Table : T_liste_cartes;
   motifs_compte : T_liste_nombre_motif;
   liste_carte : T_liste_cartes;
   nbr_motif_max : T_nbr_motif_max;
   motif_max : T_Motif;
   bool_flush : Boolean;
   combinaison_max : T_combinaison;
   bool_quinte : Boolean;
   bool_quinte_flush : Boolean;
begin
      --Definir etat de table et main du joueur
   Get(message_test); -- "update_hand table As,Ks,Qs"
   Update_data(message_test, Table, info_partie, Self, Other);
   
   Get(message_test); -- "update_hand hand self Js,Ts"
   Update_data(message_test, Table, info_partie, Self, Other);

   Get(message_test); -- "update_hand hand other Js,Ts"
   Update_data(message_test, Table, info_partie, Self, Other);
   
   liste_carte := concatenation_cartes(Get_joueur_main(Self),Table); -- TEST concatenation_cartes
   motifs_compte := compte_cartes(liste_carte); -- TEST compte_cartes
   Put_Line("Nombre de motifs differents : " & Natural'Image(Get_nbr_motif_differents(motifs_compte)));
   for motif in T_Motif LOOP
      Put_Line(T_Motif'Image(motif) & " : " & Integer'image(Get_nbr_motif(motifs_compte,motif)));
      
   end LOOP;
   Skip_Line;
   
   detecte_meilleure_motifs(motifs_compte,nbr_motif_max,motif_max); -- TEST detecte_meilleure_motifs
   Put_Line("Le motifs present le plus de fois, etant le plus haut est : " & T_Motif'Image(motif_max));
   Put_Line("Il est present" & Integer'Image(nbr_motif_max) & " fois.");
   
   Skip_Line;
   
   detecte_couleur(liste_carte,motif_max,bool_flush); -- TEST detecte_couleur
   if bool_flush THEN
      Put_Line("On detecte un flush de carte la plus haute : " & T_Motif'Image(motif_max));
      Skip_Line;
   end if;
  

   detecte_suite(liste_carte,motif_max,bool_quinte); -- TEST detecte_suite
   if bool_quinte THEN
      Put_Line("On detecte une suite de carte la plus haute : " & T_Motif'Image(motif_max));
      Skip_Line;
   end if;

   detecte_quinte_flush(liste_carte,motif_max,bool_quinte_flush);
   if bool_quinte_flush THEN
      Put_Line("On detecte une Quinte Flush de carte la plus haute : " & T_Motif'Image(motif_max));
      Skip_Line;
   end if;
   
   combinaison_max := detecte_meilleure_combinaison(liste_carte); -- TEST detecte_combinaisons
   Put_Line("La meilleure combinaison est : ");
   Put_Line(T_combinaison_nom'Image(Get_nom_combinaison(combinaison_max)) & " de " & T_Motif'Image(Get_motif1_combinaison(combinaison_max)) & " et (si combinaiason a deux motifs) " & T_Motif'Image(Get_motif2_combinaison(combinaison_max)));
   
   Put_Line("Notre bot gagne : ");
   Put_Line(Boolean'Image(Self_gagne(Combinaison_self => combinaison_max,
              Other            => Other,
              Table            => Table)));

   
end test_analyse_main;
