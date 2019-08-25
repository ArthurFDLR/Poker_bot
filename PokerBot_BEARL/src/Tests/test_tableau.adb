with Force_mains,Modelisation_poker,ada.Text_IO;
use Force_mains,Modelisation_poker,ada.Text_IO;

procedure test_tableau is

   couleurdiff: T_joueur;
   carte1: T_Carte;
   carte2: T_Carte;
   liste: T_liste_cartes;


   
begin
   --2 cartes de couleur différente
   Put_Line("_____________Couleur differente_____________");
   Set_carte(carte1,T_motif'val(7),T_couleur'val(1)); --(pique,carreau,coeur,trefle)
   Set_carte(carte2,T_motif'val(8),T_couleur'val(2)); --(deux,trois,quatre,cinq,six,sept,huit,neuf,dix,valet,reine,roi,as);
   liste := Init_liste_carte;
   Add_liste_carte(carte1,liste);
   Add_liste_carte(carte2,liste);
   Set_joueur_main(couleurdiff,liste);
   Affiche_joueur(couleurdiff);
   put_line("La probabilite de gagner au preflop est de " & float'image(puispreflop(couleurdiff)) & " %");
   --2 cartes de meme couleur    
   Put_Line("_____________Meme couleur_____________");
   Set_carte(carte1,T_motif'val(7),T_couleur'val(2)); --(pique,carreau,coeur,trefle)
   Set_carte(carte2,T_motif'val(8),T_couleur'val(2)); --(deux,trois,quatre,cinq,six,sept,huit,neuf,dix,valet,reine,roi,as);
   liste := Init_liste_carte;
   Add_liste_carte(carte1,liste);
   Add_liste_carte(carte2,liste);
   Set_joueur_main(couleurdiff,liste);
   Affiche_joueur(couleurdiff);
   put_line("La probabilite de gagner au preflop est de " & float'image(puispreflop(couleurdiff)) & " %");
end test_tableau;
