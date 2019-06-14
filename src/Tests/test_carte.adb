WITH ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;
USE  ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;

procedure Test_Carte is
   n : Integer;
   carte : T_Carte;
   carte_comparaison : T_Carte;
   carte_str : String(1..2);
   carte_str_comparaison : String(1..2);
begin
   
   Put_Line("Nombre maximal de cartes stockables au sein d'une liste : " & Integer'Image(MAX_LISTE_CARTES));
   Put("Donner une carte (ex:Ks pour le roi de pique) :");
   Get_Line(carte_str,n);
   
   carte := Carte_Str2Carte(carte_str(1..n));
   Put("Votre carte (image de T_Carte) est ");
   Affiche_carte(carte);
   
   Skip_Line;
   Skip_Line;
   
   Put("Donner une deuxieme carte (ex:Ks pour le roi de pique) pour comparer :");
   Get_Line(carte_str_comparaison,n);
   
   carte_comparaison := Carte_Str2Carte(carte_str_comparaison(1..n));
   
   if carte_comparaison > carte THEN
      Put("Elle est plus grand que la carte initiale.");
   elsif carte_comparaison < carte THEN
      Put("Elle est plus petite que la carte initiale.");
   else
      Put("Elle est equivalente a la carte initiale.");
   end if;

end Test_Carte;
