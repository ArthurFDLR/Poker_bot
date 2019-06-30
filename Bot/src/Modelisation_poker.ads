with Ada.Text_IO;
use  Ada.Text_IO;

package Modelisation_poker is -- DONE & CHECKED
   
   ---------------------------------------
   ---------------- TYPES ----------------
   ---------------------------------------

   Type T_Couleur is (pique,carreau,coeur,trefle); --s,d,h,c
   Type T_Motif is (deux,trois,quatre,cinq,six,sept,huit,neuf,dix,valet,reine,roi,as); -- 2,3,4,5,6,7,8,9,T,J,Q,K,A (par ordre de "puissance")
   Type T_moves is (fold, check, call, bet);
   Type T_Carte is private;
   Type T_liste_cartes is private;
   Type T_Jeu is private;
   Type T_joueur is private;
      
   ---------------------------------------
   ---------- PROCEDURE/FUNCTION ---------
   ---------------------------------------
   
   -- Analyse des cartes :
   
   -- Carte_Str2Carte
   -- E/ Carte : String
   -- Necessite : Carte au format du Launcher (ex : "Ks", "Th", "7d" ...)
   -- S/ Carte : T_carte
   -- Entraine : La carte au format T_carte
   Function Carte_Str2Carte (Carte_str : IN String) return T_Carte;
   
   -- Unicite_cartes
   -- E/ Liste de cartes : Liste_carte
   -- Necessite : Null
   -- S/ Boolean
   -- Entraine : True si chaque carte est unique dans la liste, False sinon
   Function Unicite_cartes(Liste_carte : IN T_liste_cartes) return Boolean;
   
   -- Manipulation de T_jeu 
   
   Procedure Set_BigBlind(jeu : OUT T_Jeu; BB : IN Natural);
   Procedure Set_SmallBlind(jeu : OUT T_Jeu; SB : IN Natural);
   Procedure Set_N_hand(jeu : OUT T_Jeu; N_hand : IN Positive);
   Procedure Set_Pot(jeu : OUT T_Jeu; Pot : IN Natural);
   Procedure Set_Amount_to_call(jeu : OUT T_Jeu; ATC : IN Natural);
   Procedure Set_Min_bet(jeu : OUT T_Jeu; MB : IN Natural);
   Procedure Set_time_to_play(jeu : OUT T_jeu; Time : Float);
   Procedure Set_Action_needed(jeu : OUT T_Jeu; state : IN Boolean);
   
   Function Get_Amount_to_call(jeu : IN T_Jeu) return Natural;
   Function Get_Pot(jeu : IN T_Jeu) return Natural;
   Function Get_N_hand(jeu : IN T_Jeu) return Positive;
   Function Get_SmallBlind(jeu : IN T_Jeu) return Natural;
   Function Get_BigBlind(jeu : IN T_Jeu) return Natural;
   Function Get_Min_bet(jeu : IN T_Jeu) return Natural;
   Function Get_time_to_play(jeu : IN T_Jeu) return Float;
   Function Get_Action_needed(jeu : IN T_Jeu) return Boolean;
   
   -- Manipulation des cartes

   MAX_LISTE_CARTES : Constant Natural := 9; -- table + 2 main
   
   Procedure Set_carte(carte : OUT T_Carte; motif : IN T_Motif; couleur : IN T_Couleur);
   Procedure Add_liste_carte(carte : IN T_Carte; liste_carte : IN OUT T_liste_cartes);
   Procedure Set_liste_carte(carte : IN T_Carte; liste_carte : IN OUT T_liste_cartes; Index : IN Natural);
   
   Function Init_liste_carte return T_liste_cartes; -- Permet de reinitialiser la table de jeu
   Function Get_nbr_liste_carte(liste_carte : IN T_liste_cartes) return Natural;
   Function Get_liste_carte(liste_carte : IN T_liste_cartes; index : IN Natural) return T_Carte;
   Function Get_carte_motif(Carte : IN T_Carte) return T_Motif;
   Function Get_carte_couleur(Carte : IN T_Carte) return T_Couleur;
   
   Function ">" (Carte_1 : IN T_Carte ; Carte_2 : IN T_Carte) return Boolean; --Uniquement base sur le motif (neglige la couleur)
   Function "<" (Carte_1 : IN T_Carte ; Carte_2 : IN T_Carte) return Boolean;
   Function "=" (Carte_1 : IN T_Carte ; Carte_2 : IN T_Carte) return Boolean;
   
   -- Manipulation de T_joueur :
   
   Procedure Set_stack(joueur : OUT T_joueur ; stack : IN Natural);
   Procedure Set_joueur_main(joueur : OUT T_joueur ; main : IN T_liste_cartes);
   Procedure Set_joueur_button(joueur : OUT T_joueur; is_button : IN Boolean);
   Procedure Set_joueur_move(joueur : OUT T_joueur; move : IN T_moves);
   Procedure Set_joueur_amount_move(joueur : OUT T_joueur; amount : IN Natural);
   
   Function Get_Stack(joueur : IN T_joueur) return Natural;
   Function Get_joueur_main(joueur : IN T_joueur) return T_liste_cartes;
   Function Get_joueur_move(joueur : IN T_joueur) return T_moves;
   Function Is_button(joueur : IN T_joueur) return Boolean;
   Function Get_joueur_amount_move(joueur : IN T_joueur) return Natural;
   
   -- Uniquement utile aux tests :
   
   procedure Affiche_carte(Carte : IN T_Carte); 
   procedure Affiche_liste_carte(liste_carte : IN T_liste_cartes);
   procedure Affiche_jeu(jeu : IN T_Jeu);
   procedure Affiche_joueur(joueur : IN T_joueur);
   
private
   
   Type T_Carte is record
      Couleur : T_couleur;
      Motif : T_Motif;
   end record;
   
   Type T_tab_cartes is Array (1..MAX_LISTE_CARTES) of T_Carte;
   
   Type T_liste_cartes is record
      cartes : T_tab_cartes;
      nbr_cartes : Natural := 0;
   end record;
   
   Type T_Jeu is record
      big_blind : Natural := 30;
      small_blind : Natural := 15;
      N_hand : Positive := 1;
      Pot : Natural := 0;
      Amount_to_call : Natural := 0;
      Min_bet : Natural := 0;
      Action_needed : Boolean := False;
      time_action : Float := 0.0;
   end record;
   
   Type T_joueur is record
      Stack : Natural :=0;
      Main : T_liste_cartes;
      Button : Boolean := False;
      move : T_moves;
      amount_move : Natural :=0;
   end record;   

end Modelisation_poker;
