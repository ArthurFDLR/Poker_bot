WITH Modelisation_poker, Ada.Text_IO;
USE  Modelisation_poker, Ada.Text_IO;

package Analyse_cartes is
   
   ---------------------------------------
   ---------------- TYPES ----------------
   ---------------------------------------
   
   Type T_combinaison_nom is (hauteur, paire, double_paire, brelan, quinte, flush, full, carre, quinte_flush);
   
   Type T_combinaison is private;
   
   Type T_liste_nombre_motif is private;
   
   Subtype T_nbr_motif_max is Integer range 0..4;
   
   ---------------------------------------
   ---------- PROCEDURE/FUNCTION ---------
   ---------------------------------------
      
   -- Analyse de la partie :
   
   -- concatenation_cartes
   -- E/ Deux listes de cartes : T_liste_cartes
   -- Necessite : Len(liste_1)+Len(liste_2) < MAX_LISTE_CARTES
   -- S/ Une liste de cartes : T_liste_cartes
   -- Entraine : Une liste de cartes constituees des cartes des deux listes initiales
   function concatenation_cartes(Liste_1 : IN T_liste_cartes ; Liste_2 : IN T_liste_cartes) return T_liste_cartes;
   
   -- detecte_meilleure_combinaison
   -- E/ Liste de cartes : T_liste_cartes
   -- Necessite : Null
   -- S/ Combinaison : T_combinaison
   -- Entraine : La meilleure combinaison de cartes possible au sein de la liste de cartes
   function detecte_meilleure_combinaison(cartes_in : IN T_liste_cartes) return T_combinaison; -- CHECKED test_analyse_main

   
   -- Manipulation de T_combinaison :
   
   function Get_nom_combinaison(combinaison : IN T_combinaison) return T_combinaison_nom;
   function Get_motif1_combinaison(combinaison : IN T_combinaison) return T_Motif;
   function Get_motif2_combinaison(combinaison : IN T_combinaison) return T_Motif;
   
   procedure Set_nom_combinaison(combinaison : OUT T_combinaison ; nom : IN T_combinaison_nom);
   procedure Set_motif1_combinaison(combinaison : OUT T_combinaison ; motif : IN T_Motif);
   procedure Set_motif2_combinaison(combinaison : OUT T_combinaison ; motif : IN T_Motif);
   
   function "="(combinaison1 : IN T_combinaison ; combinaison2 : IN T_combinaison) return Boolean;
   function ">"(combinaison1 : IN T_combinaison ; combinaison2 : IN T_combinaison) return Boolean;
   function "<"(combinaison1 : IN T_combinaison ; combinaison2 : IN T_combinaison) return Boolean;
   
   -- Manipulation de T_liste_nombre_motif :
   
   function Get_nbr_motif_differents(liste : IN T_liste_nombre_motif) return Natural;
   function Get_nbr_motif(liste : IN T_liste_nombre_motif ; motif : IN T_Motif) return T_nbr_motif_max;
   
   procedure Set_nbr_motif_differents(liste : OUT T_liste_nombre_motif ; nbr : IN Natural);
   procedure Set_nbr_motif(liste : OUT T_liste_nombre_motif ; motif : IN T_Motif ; nbr : IN T_nbr_motif_max);
   
   
private
   
   
   Type T_combinaison is record 
      nom : T_combinaison_nom;
      motif_1 : T_Motif := T_Motif'Val(0);
      motif_2 : T_Motif := T_Motif'Val(0); --optionelle dans certain cas, un type polymorphe aurait ete plus adapte mais parametrage en fonction de T_motif impossible lors de l'initialisation au seins du array T_tab_combinaison, bien plus complexe pour peu d'avantage
   end record;
   
   -- Indexation commendcant a 0 pour suivre l'indexation des motifs dans le type enumere T_motif, l'index dans la liste correspond au motif
   Type T_tab_nombre_motif is Array (0..12) of T_nbr_motif_max;
   
   Type T_liste_nombre_motif is record
      motifs : T_tab_nombre_motif;
      nbr_motifs : Natural := 0;
   end record;
   

   ----------------------------------------------------------------------
   ---------- PROCEDURES UTILES A detecte_meilleure_combinaison ---------
   ----------------------------------------------------------------------

   -- compte_cartes
   -- E/ Liste de cartes : T_liste_cartes
   -- Necessite : Null
   -- S/ Liste d'entiers (1 a 4) : T_liste_nombre_motif
   -- Entraine : Nombre d'occurence de chaques motifs au seins d'une liste de cartes
   --            La position dans la liste correspond a la position dans l'enumeration de T_motif du moti
   function compte_cartes(cartes_in : IN T_liste_cartes) return T_liste_nombre_motif;
   
      
   -- trier_cartes
   -- E/S/ Liste de cartes : T_liste_cartes
   -- Entraine : La liste de carte triee selon la hauteur du motifs (cf. T_motif)
   procedure trier_cartes(cartes_in : IN OUT T_liste_cartes); -- CHECKED test_trier_cartes
   
   -- Permet de connaitre la meilleure carte d'une liste de cartes
   -- utilise la fonction compte_cartes pour obtenir la liste_motifs d'une liste de cartes
   procedure detecte_meilleure_motifs(liste_motifs : IN T_liste_nombre_motif ; nbr_motif_max : OUT T_nbr_motif_max ; motif_max : OUT T_Motif); -- CHECKED test_analyse_main
   
   -- bool_flush True si il y a 5 cartes de la meme couleur. 
   -- motif_max est la plus haute carte de la couleur
   procedure detecte_couleur(cartes_in : IN T_liste_cartes ; motif_max : OUT T_Motif; bool_flush : OUT Boolean); -- CHECKED test_analyse_main
   
   -- bool_quinte True si il y a 5 cartes qui se suivent. 
   -- motif_max est la plus haute carte de la suite
   procedure detecte_suite(cartes_in : IN T_liste_cartes ; motif_max : OUT T_Motif; bool_quinte : OUT Boolean); -- CHECKED test_analyse_main
   
   procedure detecte_quinte_flush(cartes_in : IN T_liste_cartes ; motif_max : OUT T_Motif ; bool_quinte_flush : OUT Boolean);
   
   
end Analyse_cartes;
