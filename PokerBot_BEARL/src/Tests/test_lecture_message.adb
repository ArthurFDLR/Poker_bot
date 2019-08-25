WITH ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;
USE  ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;

procedure test_lecture_message is
   mon_message :  T_message;
   mon_mot : T_chaine;
   cartes_str : T_chaine;
   liste_cartes : T_liste_cartes;
begin
   
   -- TEST DU PROCESSUS decompose_message
   Put_Line("Inserer un message du type du Launcher (mots separe par espace) : ");
   get(mon_message);
   Put_Line(Integer'Image(Get_message_nbr_mot(mon_message)));
   for imot in 1..Get_message_nbr_mot(mon_message) loop
      --Put(mon_message.decompose(imot).line_length);
      mon_mot := Get_message_mot(mon_message,imot);
      Put(Get_chaine_line(mon_mot));
      Skip_Line;
   end loop;
   
   
   -- TEST DE LA FONCTION est_mots_clefs
   Put_Line("Un mot qui appartient ou non au type enumere T_mots_clefs_1 : ");
   get_line(mon_mot);
   
   if est_mots_clefs_1(mon_mot) then
      put("C'est bien un mot clef");
   else
      Put("Ce n'est pas un mot clef");
   end if;
   
   Skip_Line;
   
   -- TEST DE LA FONCTION lecture_cartes
   Put_Line("Inserer une liste de carte du type Launcher (Ks,Qd,4s,...) ");
   get_line(cartes_str);
   liste_cartes := lecture_cartes(cartes_str);
   
   for icarte in 1..Get_nbr_liste_carte(liste_cartes) loop
      Put("Carte " & Integer'Image(icarte) & " : " );
      Affiche_carte(Get_liste_carte(liste_cartes,icarte));
      Skip_Line;
   end loop;
end test_lecture_message;
