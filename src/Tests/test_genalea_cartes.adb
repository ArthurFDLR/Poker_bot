with ada.Text_IO,Evaluation_main, Modelisation_poker;
use ada.Text_IO,Evaluation_main, Modelisation_poker;

procedure test_GenAlea_cartes is
   liste_carte : T_liste_52cartes;
begin
   liste_carte := Generation_liste_carte;
   for i in 1..52 LOOP
      Affiche_carte(liste_carte(i));
   end loop;
   
   for i in 1..52 LOOP -- verification d'unicite des cartes dans la liste
      for j in i+1..52 LOOP
         if liste_carte(i) = liste_carte(j) THEN
            Put_Line("Recurence de cartes");
         end if;
      end loop;
   end loop;
   
end test_GenAlea_cartes;
