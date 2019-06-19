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

   function Get_puissance_main(Table : IN T_liste_cartes ; Self : T_joueur ; Limite_duree : IN Float) return Natural;
   
private
   
   type T_Numero is range 1..52;
   type T_liste_52int is array(1..52) of T_Numero;
   Type T_winpreflop is array (0..12,0..12) of float;
   Data_winPreFlop : Constant T_winpreflop := ((0.849319155,0.662196077,0.653136987,0.643976206,0.634889152,0.615096738,0.605078092,0.593866724,0.581788979,0.580641194,0.571377993,0.563350536,0.555062605),
                                               (0.644693779,0.821173352,0.624084198,0.614765567,0.605870651,0.586381395,0.567904101,0.558463209,0.548046714,0.538338521,0.528888435,0.52070127,0.512399522),
                                               (0.635087873,0.604322528,0.7963199,0.590708761,0.581706398,0.562227963,0.544170186,0.525234865,0.516792442,0.507134502,0.497630373,0.489384093,0.481018159),
                                               (0.625351751,0.594412333,0.569062317,0.771529795,0.561547809,0.541119845,0.523116531,0.50454458,0.485742447,0.478209446,0.468686679,0.460417502,0.452024408),
                                               (0.615680842,0.584942841,0.559473896,0.538260051,0.746602649,0.523768735,0.505091478,0.486512336,0.468001976,0.449390253,0.442040694,0.433784834,0.425401609),
                                               (0.594497413,0.564076436,0.538620039,0.516393807,0.498156956,0.71665652,0.48856274,0.469902897,0.451511669,0.433127074,0.414071227,0.408067893,0.399729546),
                                               (0.583741555,0.544316335,0.519305219,0.497136574,0.478181051,0.460683321,0.687173824,0.456841078,0.438185112,0.419904598,0.401027785,0.382825625,0.376792221),
                                               (0.571695154,0.534173281,0.499043646,0.477261306,0.458297636,0.440720598,0.426932942,0.657253537,0.428294766,0.409790051,0.391089085,0.373035564,0.354398378),
                                               (0.558703056,0.522971205,0.489965008,0.45713539,0.438481246,0.42103393,0.406965845,0.396538119,0.627000236,0.403481875,0.384809773,0.366854297,0.348375477),
                                               (0.55742294,0.512539174,0.479589999,0.449046479,0.418574755,0.401367204,0.38741271,0.376746842,0.370127552,0.596400354,0.385325316,0.367586767,0.349295353),
                                               (0.547328704,0.502251544,0.469247654,0.438687349,0.410553886,0.380857956,0.367091719,0.356617288,0.350029887,0.350748203,0.56256514,0.357273581,0.339179444),
                                               (0.53855312,0.493312642,0.460248971,0.429667624,0.40155186,0.374279138,0.347498492,0.337179107,0.330697893,0.331649813,0.32066305,0.528392366,0.330919716),
                                               (0.529473055,0.484227823,0.451099302,0.420492657,0.392391147,0.36517013,0.340868297,0.3171028,0.310786557,0.311938073,0.301174066,0.292394496,0.49385176));
   
   
   function Association_nbr_carte(nbr : IN T_Numero) return T_Carte;
   function Generation_liste_int return T_liste_52int;
   procedure Echange_elem_liste(liste : IN OUT T_liste_52int ; i : IN Integer ; j : IN Integer);

   -- puispreflop
   -- E/ Joueur : T_joueur
   -- Necessite : la table doit etre vide
   -- S/ Float
   -- Entraine : renvoie le pourcentage de gagner la partie
   Function puispreflop(joueur: IN T_joueur) return Float;
   
   -- pourcentage_gagne_PostFlop_NoLimit
   -- E/ Table : T_liste_cartes ; Joueur : T_joueur
   -- Necessite : Une table comportant au moin 3 cartes et un joueur dont on connait la main
   -- S/ Pourcentage : Natural
   -- Entraine : Le pourcentage de gain du joueur apres le flop en simulant toutes les cartes necessaire a completer la table et le joueur adverse
   function pourcentage_gagne_PostFlop_NoLimit(Table : IN T_liste_cartes ; Self : T_joueur) return Natural;
   
   function pourcentage_gagne_PostFlop_TimeLimited(Table : IN T_liste_cartes ; Self : T_joueur ; Limite_duree : IN Float) return Natural;

end Evaluation_main;
