With Modelisation_poker, lecture_messages, Ada.Text_IO, Evaluation_main;
Use  Modelisation_poker, lecture_messages, Ada.Text_IO, Evaluation_main;

package strategie_adversaire is
   
   ---------------------------------------
   ---------------- TYPES ----------------
   ---------------------------------------
   
   --Les differents profils de l'adversaire possibles
   type T_profil_adversaire is (Frileux,Con,Couillu,Suisse);
   
   type T_tour is private;
   type stockage_tours_tab is private;
   type stockage_tours is private;
   
   ---------------------------------------
   ---------- PROCEDURE/FUNCTION ---------
   ---------------------------------------
   
   -- determination_profil_adversaire
   -- E/ jeu : T_Jeu ; self,other : T_joueur ; Table : T_liste_cartes; puissance_self : Natural
   -- E/S/ stockage : stockage _tours
   -- S/ Profil : T_profil_adversaire
   -- Entraine : Determine le profil de l'adversaire 
   procedure determination_profil_adversaire(jeu : in T_Jeu; self,other : in T_joueur; table : in T_liste_cartes; stockage : in out stockage_tours;puissance_self : in Natural; profil : out T_profil_adversaire);
   
   private
   
   N_max_tour : Integer := 1000;
   
   ---------------------------------------
   -------------TYPES PRIVES -------------
   ---------------------------------------
   
   type T_tour is record
      big_blind : Natural := 20;
      small_blind : Natural := 10;
      N_hand : Natural := 0;
      Pot : Natural := 0;
      Amount_to_call : Natural := 0;
      Min_bet : Natural := 0;
      Stack_self : Natural :=0;
      Main_self : T_liste_cartes;
      Button_self : Boolean := False;
      Stack_other : Natural :=0;
      Main_other : T_liste_cartes;
      Table : T_liste_cartes;
      puissance_main_self : Natural := 0;
      puissance_main_other : Natural := 0;      
      self : T_joueur;
      other : T_joueur;
      Amount_move_other : Natural := 0;
   end record;         
   type stockage_tours_tab is array (1..N_max_tour) of T_tour;   
   type stockage_tours is record
      tours : stockage_tours_tab;
      nb_tours : Natural := 0;
   end record;
   
   ---------------------------------------
   ----- PROCEDURE/FUNCTION PRIVEES ------
   ---------------------------------------
   
   procedure stocke_tour(jeu : in T_Jeu; self,other : in T_joueur; table : in T_liste_cartes; stockage : in out stockage_tours;puissance_self : in Natural);
   procedure Profil_adversaire(stockage : in stockage_tours; profil : out T_profil_adversaire);
 
   -- Uniquement utile aux tests :
   
   procedure init_sauvegarde_tour(fichier: in File_Type);   
   procedure sauvegarde_tour(fichier : in File_Type; stockage : in stockage_tours);   
   procedure affiche_stockage_tours(stockage : in stockage_tours; index : in Natural);       
   function trouver_indice_tours(stockage : in stockage_tours; N_hand : in Positive; N_tour : in positive) return Natural;
   
   
   
    
   

end strategie_adversaire;
