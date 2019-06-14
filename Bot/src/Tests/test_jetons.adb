WITH ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;
USE  ada.text_io, ada.Integer_Text_IO, Modelisation_poker, lecture_messages, Analyse_cartes;

procedure test_jetons is
   Partie : T_Jeu;
   self : T_joueur;
   other : T_joueur;
   echange : Integer;
   quantite_i : Natural;
   quantite_j : Natural;
begin
   Put_Line("Quantite de jeton initial pour chaques joueurs puis dans le pot :");
   get(quantite_i);
   get(quantite_j);
   Set_Pot(jeu => Partie,
           Pot => quantite_j);
   Set_stack(joueur => self,
             stack  => quantite_i);
   Set_stack(joueur => other,
             stack  => quantite_i);
   
   Set_stack(joueur => self,
             stack  => Get_Stack(self) - Get_BigBlind(Partie));
   Set_stack(joueur => other,
             stack  => Get_Stack(other) - Get_SmallBlind(Partie));
   Set_Pot(jeu => Partie,
           Pot => Get_Pot(Partie) + Get_BigBlind(Partie) + Get_SmallBlind(Partie));
   
   Skip_Line;
   Put_Line("Quantite de jeton apres placement des blind ; Moi : " & Natural'image(Get_Stack(self)) & " ; autre : " & Natural'image(Get_Stack(other)));
   
   Put_Line("Quantite de jeton place dans le pot par moi: ");
   get(echange);
   Set_Pot(jeu => Partie,
           Pot => Get_Pot(Partie) + echange);
   Set_stack(joueur => self,
             stack  => Get_Stack(self) - echange);
   
   Put_Line("Quantite de jeton place dans le pot par moi (positif ou negatif i.e. gain ou perte): ");
   Put_Line("Quantite final de jeton au tour " & Positive'Image(Get_N_hand(Partie)) & " ; " & " Pot : " & Natural'image(Get_Pot(Partie)) & " ; Moi : " & Natural'image(Get_Stack(self)) & " ; Autre : " & Natural'image(Get_Stack(other)));
end test_jetons;
