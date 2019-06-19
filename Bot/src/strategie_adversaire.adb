with ada.Text_IO, ada.Integer_Text_IO; use ada.Text_IO, ada.Integer_Text_IO;
package body strategie_adversaire is

   procedure stocke_tour(jeu : in T_Jeu; self,other : in T_joueur; table : in T_liste_cartes; stockage : in out stockage_tours; puissance_self : in natural) is
      i : Natural;
   begin
      i := stockage.nb_tours+1;
      stockage.tours(i).self := self;
      stockage.tours(i).other := other;
      stockage.tours(i).big_blind := Get_BigBlind(jeu);
      stockage.tours(i).small_blind := Get_SmallBlind(jeu);
      stockage.tours(i).N_hand := Get_N_hand(jeu);
      stockage.tours(i).Pot := Get_Pot(jeu);
      stockage.tours(i).Amount_to_call := Get_Amount_to_call(jeu);
      stockage.tours(i).Min_bet := Get_Min_bet(jeu);
      stockage.tours(i).Stack_self := Get_Stack(self);
      stockage.tours(i).Stack_other := Get_Stack(other);
      stockage.tours(i).Main_self := Get_joueur_main(self);
      stockage.tours(i).Main_other := Get_joueur_main(other);
      stockage.tours(i).Button_self := Is_button(self);
      stockage.tours(i).Table := table;
      stockage.tours(i).puissance_main_self := puissance_self;
      stockage.tours(i).Amount_move_other := Get_joueur_amount_move(other);
      stockage.nb_tours := i ;

   end stocke_tour;

   procedure init_sauvegarde_tour(fichier : in File_Type) is
   begin
      Put_line(fichier, "num tour;num main;BigBlind;SmallBlind;Pot;Amount to Call;Min bet;Stack self;Stack other;Puissance Main Self;Puissance main adv;move other;jetons depenses;carte adv");

   end init_sauvegarde_tour;


   procedure sauvegarde_tour(fichier : in File_Type; stockage : in stockage_tours) is
      i : Natural := stockage.nb_tours;
   begin
      put(fichier, i);
      put(fichier, ";");
      put(fichier, stockage.tours(i).N_hand);
      put(fichier, ";");
      put(fichier, stockage.tours(i).big_blind);
      put(fichier, ";");
      Put(fichier, stockage.tours(i).small_blind);
      put(fichier, ";");
      put(fichier, stockage.tours(i).Pot);
      put(fichier, ";");
      put(fichier, stockage.tours(i).Amount_to_call);
      put(fichier, ";");
      put(fichier, stockage.tours(i).Min_bet);
      put(fichier, ";");
      put(fichier, stockage.tours(i).Stack_self);
      put(fichier, ";");
      put(fichier, stockage.tours(i).Stack_other);
      put(fichier, ";");
      if Get_nbr_liste_carte(stockage.tours(i).Table) > 3 then
            put(fichier, pourcentage_gagne_PostFlop_NoLimit(stockage.tours(i).Table,stockage.tours(i).self));
      else
         put(fichier, 50);
      end if;
      put(fichier, ";");
      put(fichier, T_moves'image(Get_joueur_move(stockage.tours(i).other)));
      put(fichier, ";");
      put(fichier, stockage.tours(i).Amount_move_other);
      put(fichier, ";");
      put(fichier, (Get_nbr_liste_carte(Get_joueur_main(stockage.tours(i).other))));
      put(fichier, ";");
      New_Line(fichier);

   end sauvegarde_tour;



   procedure affiche_stockage_tours(stockage : in stockage_tours; index : in Natural) is
   begin
      put("numero tour : "); Put(index); New_Line;
      put("Big Blind : "); Put(stockage.tours(index).big_blind); New_Line;
      put("Small Blind : "); Put(stockage.tours(index).small_blind);New_Line;
      put("numero main : "); Put(stockage.tours(index).N_hand); New_Line;
      put("Pot : "); Put(stockage.tours(index).Pot);New_Line;
      put("Amount_to_call : "); Put(stockage.tours(index).Amount_to_call); New_Line;
      put("Min bet : "); Put(stockage.tours(index).Min_bet); New_Line;
      put("Stack self : "); Put(stockage.tours(index).Stack_self); New_Line;
      put("Stack Other : "); Put(stockage.tours(index).Stack_other); New_Line;
      put("Main self : "); Affiche_liste_carte(stockage.tours(index).Main_self);
      put("Main other : "); Affiche_liste_carte(stockage.tours(index).Main_other);
      put("Button self : "); Put_Line(Boolean'Image(stockage.tours(index).Button_self));
      put("Table : "); Affiche_liste_carte(stockage.tours(index).Table);

   end affiche_stockage_tours;

   function trouver_indice_tours(stockage : in stockage_tours; N_hand : in Positive; N_tour : in positive) return Natural is
      k : integer := 0;
      tours : integer := 0;
   begin
      while stockage.tours(k).N_hand < N_hand loop
         tours := tours + 1;
      end loop;
      tours := tours + N_tour;
      return tours;
   end trouver_indice_tours;

   procedure Profil_adversaire(stockage : in stockage_tours; profil : out T_profil_adversaire) is
      i : Natural := stockage.nb_tours;
      F,Cn,C : Float := 0.0;
      Cu : Float := 1.0 ;
      tour, tour_prec : T_tour;
      nb_pari : float := 1.0 ;
      n_acces_cartes_adv : natural := 0;

   begin


      For t in 1..i loop
         tour := stockage.tours(t);
         if Get_nbr_liste_carte(Get_joueur_main(tour.other)) > 1 then
            n_acces_cartes_adv := n_acces_cartes_adv + 1;
            C := ((float(pourcentage_gagne_PostFlop_TimeLimited(Table=> tour.Table,Self=> tour.other,Limite_duree => 0.1))/float(tour.puissance_main_self))+C)/float(n_acces_cartes_adv);
         end if;

         if Get_joueur_move(tour.self) = Fold then
            If tour.puissance_main_self > 70 then
               Cu := Cu - 0.02;
            end if;
         end if;

         if Get_joueur_move(tour.other) = call or Get_joueur_move(tour.other) = bet then
            tour_prec := stockage.tours(t-1);
            if tour.Stack_other /= tour_prec.Stack_other then --eviter les redondances
               F := F+Float(tour.Amount_move_other)/Float(tour.Stack_other);
               nb_pari := nb_pari +1.0;
            end if;
         end if;

      end loop;

      Cu := C*Cu;
      F:=F/(nb_pari-1.0);
      Cn := 1.0-F;

      if F<Cn and F<Cu then
         profil := Frileux;
      elsif Cn < F and Cn < Cu then
         profil := Con;
      elsif Cu < F and Cu < Cn then
         profil := couillu;
      else profil := Suisse;
      end if;


   end Profil_adversaire;

   procedure determination_profil_adversaire(jeu : in T_Jeu; self,other : in T_joueur; table : in T_liste_cartes; stockage : in out stockage_tours;puissance_self : in Natural; profil : out T_profil_adversaire) is
   begin
      stocke_tour(jeu            => jeu,
                  self           => self,
                  other          => other,
                  table          => table,
                  stockage       => stockage,
                  puissance_self => puissance_self);
      Profil_adversaire(stockage => stockage,
                        profil   => profil)  ;

   end determination_profil_adversaire;



end strategie_adversaire;