package body Analyse_cartes is

   
   procedure trier_cartes(cartes_in : IN OUT T_liste_cartes) is
      carte_tmp : T_Carte;
      continuer : Boolean := True;
   Begin
      while (continuer = True) LOOP
         continuer := False;
         for i in 1 .. (Get_nbr_liste_carte(cartes_in)-1) LOOP
            if (T_Motif'Pos(Get_carte_motif(Get_liste_carte(cartes_in, i))) > T_Motif'Pos(Get_carte_motif(Get_liste_carte(cartes_in, i + 1)))) THEN
               Continuer := True;
               
               carte_tmp := Get_liste_carte(cartes_in, i);
               Set_liste_carte(carte       => Get_liste_carte(cartes_in, i+1),
                               liste_carte => cartes_in,
                               Index       => i);
               Set_liste_carte(carte       => carte_tmp,
                               liste_carte => cartes_in,
                               Index       => i+1);
            end if;
         end loop ;
      end loop;
   end trier_cartes;

   
   function concatenation_cartes(Liste_1 : IN T_liste_cartes ; Liste_2 : IN T_liste_cartes) return T_liste_cartes is
      cartes : T_liste_cartes;
   Begin
      for icarte in 1 .. Get_nbr_liste_carte(Liste_1) LOOP
         Add_liste_carte(carte       => Get_liste_carte(Liste_1,icarte),
                         liste_carte => cartes); 
      end loop;
      for icarte in 1 .. Get_nbr_liste_carte(Liste_2) LOOP
         Add_liste_carte(carte       => Get_liste_carte(Liste_2,icarte),
                         liste_carte => cartes);
      end loop;
      return cartes;
   end concatenation_cartes;

   
   function compte_cartes(cartes_in : IN T_liste_cartes) return T_liste_nombre_motif is
      liste_motifs : T_liste_nombre_motif;
   Begin
      for i in 0..12 LOOP -- Initialisation de la liste
         liste_motifs.motifs(i) := 0;
      end loop;
      
      for icarte in 1 .. Get_nbr_liste_carte(cartes_in) LOOP
         if liste_motifs.motifs(T_Motif'Pos(Get_carte_motif(Get_liste_carte(cartes_in,icarte)))) = 0 THEN --On compte le motif nouvellement decouvert
            liste_motifs.nbr_motifs := liste_motifs.nbr_motifs + 1;
         end if;
         liste_motifs.motifs(T_Motif'Pos(Get_carte_motif(Get_liste_carte(cartes_in,icarte)))) := liste_motifs.motifs(T_Motif'Pos(Get_carte_motif(Get_liste_carte(cartes_in,icarte)))) +1; --On compte la carte de cartes_in au bon index (motif)
      end LOOP;
      return liste_motifs;
   end compte_cartes;
   
   procedure detecte_meilleure_motifs(liste_motifs : IN T_liste_nombre_motif ; nbr_motif_max : OUT T_nbr_motif_max ; motif_max : OUT T_Motif) is
   Begin
      nbr_motif_max := 0; 
      for i in 0..12 LOOP --Recherche du motif avec un max de carte
         if nbr_motif_max < liste_motifs.motifs(i) THEN
            nbr_motif_max := liste_motifs.motifs(i);
            motif_max := T_Motif'Val(i);
         elsif nbr_motif_max = liste_motifs.motifs(i) and motif_max < T_Motif'Val(i) THEN --Dans le cas ou il y a un meme nombre de carte du meme motif on prend l'ensemble de carte dont le motif est le plus fort : permet de choisir la combinaison la plus forte
            motif_max := T_Motif'Val(i);
         end if;
      end LOOP;
   end detecte_meilleure_motifs;
   
   procedure detecte_couleur(cartes_in : IN T_liste_cartes ; motif_max : OUT T_Motif; bool_flush : OUT Boolean) is -- bool_flush True si il y a 5 cartes de la meme couleur. motif_max est la plus haute carte 
      nbr_carte_couleur : Integer :=0;
      couleur_courante : T_Couleur;
   Begin
      bool_flush := False;
      motif_max := T_Motif'Val(0);
      for i in 1..3 LOOP -- Si les trois premieres cartes sont de couleures differentes et que les autres ne sont aps toute de la meme qu'une des trois alors il n'y a pas de flush : on regarde que les trois premiere cartes               
         if bool_flush = False THEN -- Si on a pas deja detecte une flush
            couleur_courante := Get_carte_couleur(Get_liste_carte(cartes_in,i)); 
            nbr_carte_couleur := 1;
            for j in i .. Get_nbr_liste_carte(cartes_in) LOOP --on regarde les cartes suivantes
               if couleur_courante = Get_carte_couleur(Get_liste_carte(cartes_in,j)) THEN -- +1 quand c'est la meme couleur
                  nbr_carte_couleur := nbr_carte_couleur + 1;
               end IF;
               if Get_carte_motif(Get_liste_carte(cartes_in,j)) > motif_max THEN --On selectionne la plus grande carte appartenant au flush
                  motif_max := Get_carte_motif(Get_liste_carte(cartes_in,j));
               end if;
            end LOOP;
            if nbr_carte_couleur > 4 THEN --S'il y a plus de 5 cartes -> flush
               bool_flush := True;
            end if;
         end if;
      end LOOP;
      
   end detecte_couleur;
   
   function detecte_meilleure_combinaison(cartes_in : IN T_liste_cartes) return T_combinaison is
      --liste_combinaison : T_liste_combinaison;
      nbr_motif_max : T_nbr_motif_max := 1; --4 cartes de la meme couleur au max (tricheurs ...)
      motif_max : T_Motif;
      liste_motifs : T_liste_nombre_motif;
      bool_flush : Boolean := False;
      Combinaison_max : T_combinaison;
      bool_quinte : Boolean := False;
      bool_quinte_flush : Boolean := False;
   Begin
      liste_motifs := compte_cartes(cartes_in);
      detecte_meilleure_motifs(liste_motifs, nbr_motif_max, motif_max);
      Case nbr_motif_max is
         when 0 => -- Si on a aucune carte, impossible
            null;
         when 1 => --Si on a que des cartes deparaille
            Combinaison_max.nom := T_combinaison_nom'Val(0); -- hauteur
            Combinaison_max.motif_1 := motif_max;
         when 2 => --Si on a une paire
            Combinaison_max.nom := T_combinaison_nom'Val(1); -- paire
            Combinaison_max.motif_1 := motif_max;
            
            liste_motifs.motifs(T_Motif'Pos(motif_max)) := 0; --Elimine la conbinaison de carte de la liste des motifs qu'on vient de placer dans la liste de combinaison
            detecte_meilleure_motifs(liste_motifs, nbr_motif_max, motif_max); --Selectionne la deuxieme meilleure combi dans la main, potentiellement une paire pour faire une double paire
            if nbr_motif_max > 1 THEN
               Combinaison_max.nom := T_combinaison_nom'Val(2); -- remplacer par double paire
               Combinaison_max.motif_2 := motif_max;
            end if;
            
         when 3 => --Si on a un brelan
            Combinaison_max.nom := T_combinaison_nom'Val(3); -- brelan
            Combinaison_max.motif_1 := motif_max;
            
            liste_motifs.motifs(T_Motif'Pos(motif_max)) := 0; --Elimine la conbinaison de carte de la liste des motifs qu'on vient de placer dans la liste de combinaison
            detecte_meilleure_motifs(liste_motifs, nbr_motif_max, motif_max); --Selectionne la deuxieme meilleure combi dans la main, potentiellement une paire ou un brelan pour faire un full
            if nbr_motif_max > 1 THEN
               Combinaison_max.nom := T_combinaison_nom'Val(6); -- full qui remplace le brelan trouve avant
               Combinaison_max.motif_2 := motif_max; -- Le motif 1 est inchange, le 2 est celui de la paire ou du brelan qui complete
            end if;
            
         when 4 => --Si on a un carre
            Combinaison_max.nom := T_combinaison_nom'Val(7); -- carre
            Combinaison_max.motif_1 := motif_max;
      end case;
      
      detecte_suite(cartes_in,motif_max,bool_quinte);-- Si on trouve une suite dans la main
      if bool_quinte THEN
         if 4 > T_combinaison_nom'Pos(Combinaison_max.nom) THEN -- et si c'est mieux que ce qu'on a actuellement :
            Combinaison_max.nom := T_combinaison_nom'Val(4); --Quinte
            Combinaison_max.motif_1 := motif_max;
         end if;
      end if;
      
      detecte_couleur(cartes_in,motif_max,bool_flush); -- Si on trouve une couleur dans la main
      if bool_flush THEN
         if 5 > T_combinaison_nom'Pos(Combinaison_max.nom) THEN -- et si c'est mieux que ce qu'on a actuellement :
            Combinaison_max.nom := T_combinaison_nom'Val(5); --Flush
            Combinaison_max.motif_1 := motif_max;
         end if;
      end if;
      
      detecte_quinte_flush(cartes_in,motif_max,bool_quinte_flush); -- Si on trouve une couleur dans la main
      if bool_quinte_flush THEN
         Combinaison_max.nom := T_combinaison_nom'Val(8); --Quinte Flush
         Combinaison_max.motif_1 := motif_max;
      end if;
   return Combinaison_max;
   end detecte_meilleure_combinaison;
   
   procedure detecte_suite(cartes_in : IN T_liste_cartes ; motif_max : OUT T_Motif; bool_quinte : OUT Boolean) is
      nbr_carte_suite : Natural := 0;
      liste_motifs : T_liste_nombre_motif;
   Begin
      liste_motifs := compte_cartes(cartes_in);
      bool_quinte := False;
      
      if liste_motifs.nbr_motifs > 4 THEN -- Il faut au moin 5 carets de motifs differents pour faire une suite
         for i in 0..13 LOOP
            if i = 13 THEN
               if nbr_carte_suite > 4 THEN
                  bool_quinte := True;
                  motif_max := T_Motif'Val(i-1); --Si on sort d'une suite de 5 cartes, la carte scrute precedement est celle de plus haut motif
               end IF;
            else
               if liste_motifs.motifs(i) > 0 THEN
               nbr_carte_suite := nbr_carte_suite + 1;
               else
                  if nbr_carte_suite > 4 THEN
                     bool_quinte := True;
                     motif_max := T_Motif'Val(i-1); --Si on sort d'une suite de 5 cartes, la carte scrute precedement est celle de plus haut motif
                  end IF;
               nbr_carte_suite :=0;
               end IF;
            end if;
         end LOOP;
      end IF;
      
      -- Detecte suite commencant par As
      nbr_carte_suite := 0;
      
      for i in 0..4 LOOP
         if liste_motifs.motifs(i) > 0 THEN
            nbr_carte_suite := nbr_carte_suite + 1;
         end if;
      end LOOP;
      
      if nbr_carte_suite = 4 and liste_motifs.motifs(12) > 0 THEN
         bool_quinte := True;
         motif_max := T_Motif'Val(3);
      end if;
      
   end detecte_suite;

   procedure detecte_quinte_flush(cartes_in : IN T_liste_cartes ; motif_max : OUT T_Motif ; bool_quinte_flush : OUT Boolean) is
      nbr_carte_couleur : Integer :=0;
      couleur_courante : T_Couleur;
      liste_carte_tmp : T_liste_cartes;
      bool_flush : Boolean;
      bool_quinte : Boolean;
   Begin
      bool_quinte_flush := False;
      bool_quinte := False;
      bool_flush := False;
      
      liste_carte_tmp := Init_liste_carte;
      
      motif_max := T_Motif'Val(0);
      
      for i in 1..3 LOOP -- Si les trois premieres cartes sont de couleures differentes et que les autres ne sont aps toute de la meme qu'une des trois alors il n'y a pas de flush : on regarde que les trois premiere cartes               
         if bool_flush = False THEN -- Si on a pas deja detecte une flush
            couleur_courante := Get_carte_couleur(Get_liste_carte(cartes_in,i)); 
            nbr_carte_couleur := 1;
            for j in i .. Get_nbr_liste_carte(cartes_in) LOOP --on regarde les cartes suivantes
               if couleur_courante = Get_carte_couleur(Get_liste_carte(cartes_in,j)) THEN -- +1 quand c'est la meme couleur
                  nbr_carte_couleur := nbr_carte_couleur + 1;
                  Add_liste_carte(carte       => Get_liste_carte(cartes_in,j),
                                  liste_carte => liste_carte_tmp);
               else
                  liste_carte_tmp := Init_liste_carte;
               end IF;
               if Get_carte_motif(Get_liste_carte(cartes_in,j)) > motif_max THEN --On selectionne la plus grande carte appartenant au flush
                  motif_max := Get_carte_motif(Get_liste_carte(cartes_in,j));
               end if;
            end LOOP;
            if nbr_carte_couleur > 4 THEN --S'il y a plus de 5 cartes -> flush
               bool_flush := True;
            end if;
         end if;
      end LOOP;
      
      detecte_suite(cartes_in   => liste_carte_tmp,
                    motif_max   => motif_max,
                    bool_quinte => bool_quinte);
      
      if bool_quinte and bool_flush THEN
         bool_quinte_flush := True;
      end if;
      
   end;
   
   
   -----------------------------------
   -- Manipulation de T_combinaison --
   -----------------------------------
   
   function Get_nom_combinaison(combinaison : IN T_combinaison) return T_combinaison_nom is
   Begin
      return combinaison.nom;
   end;
   
   function Get_motif1_combinaison(combinaison : IN T_combinaison) return T_Motif is
   Begin
      return combinaison.motif_1;
   end;
   
   function Get_motif2_combinaison(combinaison : IN T_combinaison) return T_Motif is
   Begin
      if combinaison.nom = T_combinaison_nom'Val(2) or combinaison.nom = T_combinaison_nom'Val(6) THEN
         return combinaison.motif_2;
      else
         Put_Line(Standard_Error,"Appel d'un motif inexistant");
         return combinaison.motif_2;
      end if;
   end;
   
   function "="(combinaison1 : IN T_combinaison ; combinaison2 : IN T_combinaison) return Boolean is
      bool : Boolean := False;
   Begin
      if combinaison1.nom = combinaison2.nom and combinaison1.motif_1 = combinaison2.motif_1 and combinaison1.motif_2 = combinaison2.motif_2 THEN
         bool := True;
      end if;
      return bool;
   end;
   

   
   function ">"(combinaison1 : IN T_combinaison ; combinaison2 : IN T_combinaison) return Boolean is
      bool : Boolean := False;
   Begin
      if T_combinaison_nom'Pos(combinaison1.nom) > T_combinaison_nom'Pos(combinaison2.nom) THEN
         bool := True;
      elsif T_combinaison_nom'Pos(combinaison1.nom) = T_combinaison_nom'Pos(combinaison2.nom) THEN
         if T_Motif'Pos(combinaison1.motif_1) > T_Motif'Pos(combinaison2.motif_1) THEN
            bool := True;
         elsif T_Motif'Pos(combinaison1.motif_1) = T_Motif'Pos(combinaison2.motif_1) THEN
            if  T_Motif'Pos(combinaison1.motif_2) > T_Motif'Pos(combinaison2.motif_2) THEN
               bool := True;
            end if;
         end if;
      end if;
      return bool;
   End;
   
   function "<"(combinaison1 : IN T_combinaison ; combinaison2 : IN T_combinaison) return Boolean is
   Begin
      return combinaison2 > combinaison1;
   end;
   
   procedure Set_nom_combinaison(combinaison : OUT T_combinaison ; nom : IN T_combinaison_nom) is
   Begin
      combinaison.nom := nom;
   end;
   
   procedure Set_motif1_combinaison(combinaison : OUT T_combinaison ; motif : IN T_Motif) is
   Begin
      combinaison.motif_1 := motif;
   end;
   
   procedure Set_motif2_combinaison(combinaison : OUT T_combinaison ; motif : IN T_Motif) is
   Begin
      combinaison.motif_2 := motif;
   end;
      
   ------------------------------------------
   -- Manipulation de T_liste_nombre_motif --
   ------------------------------------------
   
   function Get_nbr_motif_differents(liste : IN T_liste_nombre_motif) return Natural is
   Begin
      Return liste.nbr_motifs;
   End;
   
   function Get_nbr_motif(liste : IN T_liste_nombre_motif ; motif : IN T_Motif) return T_nbr_motif_max is
   Begin
      Return liste.motifs(T_Motif'Pos(motif));
   End;
   
   procedure Set_nbr_motif_differents(liste : OUT T_liste_nombre_motif ; nbr : IN Natural) is
   Begin
      liste.nbr_motifs := nbr;
   End;
   
   procedure Set_nbr_motif(liste : OUT T_liste_nombre_motif ; motif : IN T_Motif ; nbr : IN T_nbr_motif_max) is
   Begin
      liste.motifs(T_Motif'Pos(motif)) := nbr;
   End;

   
end Analyse_cartes;
