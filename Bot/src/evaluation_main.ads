With Ada.Calendar, Ada.Text_IO, Modelisation_poker, Analyse_cartes;
Use  Ada.Calendar, Ada.Text_IO, Modelisation_poker, Analyse_cartes;

package Evaluation_main is -- En cours d'ecriture
   
   ---------------------------------------
   ---------------- TYPES ----------------
   ---------------------------------------
      
   type T_liste_52cartes is array(1..52) of T_Carte;
   
   ---------------------------------------
   ---------- PROCEDURE/FUNCTION ---------
   ---------------------------------------

   -- Generation_liste_carte
   -- E/ Null
   -- S/ Liste de 52 cartes : T_liste_52cartes
   -- Entraine : Une liste de 52 cartes (1..52) sans repetition dans un ordre aleatoire
   function Generation_liste_carte return T_liste_52cartes;
   
   -- Self_gagne
   -- E/ Combinaison de carte de self : T_combinaison ; 2 joueur : T_joueur ; Table : T_table
   -- Necessite : Une combinaison de carte obtenue par la fonction detecte_meilleure_combinaison, un joueur dont la main est renseignee
   -- S/ Boolean
   -- Entraine : True si la combinaison fournie bat les cartes du joueur avec la table donnee, False sinon
   -- Note : On fournie ici combinaison_self pour ne pas avoir a le recalculer a chaque appel de Self_gagne
   function Self_gagne(Combinaison_self : IN T_combinaison; Self : IN T_joueur ; Other : IN T_joueur ; Table : IN T_liste_cartes) return Boolean;

      
   -- pourcentage_gagne_PostFlop_NoLimit
   -- E/ Table : T_liste_cartes ; Joueur : T_joueur
   -- Necessite : Une table comportant au moin 3 cartes et un joueur dont on connait la main
   -- S/ Pourcentage : Natural
   -- Entraine : Le pourcentage de gain du joueur apres le flop en simulant toutes les cartes necessaire a completer la table et le joueur adverse
   function pourcentage_gagne_PostFlop_NoLimit(Table : IN T_liste_cartes ; Self : T_joueur) return Natural;
   
   function pourcentage_gagne_PostFlop_TimeLimited(Table : IN T_liste_cartes ; Self : T_joueur ; Limite_duree : IN Float) return Natural;

   
private
   
   type T_Numero is range 1..52;
   type T_liste_52int is array(1..52) of T_Numero;
   
   function Association_nbr_carte(nbr : IN T_Numero) return T_Carte;
   function Generation_liste_int return T_liste_52int;
   procedure Echange_elem_liste(liste : IN OUT T_liste_52int ; i : IN Integer ; j : IN Integer);

end Evaluation_main;
