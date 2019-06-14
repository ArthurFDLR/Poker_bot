package body Modelisation_poker IS
   
   
   Function Carte_Str2Carte (Carte_str : IN String) return T_Carte is
      carte : T_Carte;
   Begin
      
      case Carte_str(Carte_str'First + 1) is
         when 's' => carte.Couleur := T_Couleur'Val(0) ;
         when 'd' => carte.Couleur := T_Couleur'Val(1) ;
         when 'h' => carte.Couleur := T_Couleur'Val(2) ;
         when 'c' => carte.Couleur := T_Couleur'Val(3) ;
         when others => null ;
      end case;
            
      case Carte_str(Carte_str'First) is
         when '2' => carte.Motif := T_Motif'val(0) ;
         when '3' => carte.Motif := T_Motif'val(1) ;
         when '4' => carte.Motif := T_Motif'val(2) ;
         when '5' => carte.Motif := T_Motif'val(3) ;
         when '6' => carte.Motif := T_Motif'val(4) ;
         when '7' => carte.Motif := T_Motif'val(5) ;
         when '8' => carte.Motif := T_Motif'val(6) ;
         when '9' => carte.Motif := T_Motif'val(7) ;
         when 'T' => carte.Motif := T_Motif'val(8) ;
         when 'J' => carte.Motif := T_Motif'val(9) ;
         when 'Q' => carte.Motif := T_Motif'val(10) ;
         when 'K' => carte.Motif := T_Motif'val(11) ;
         when 'A' => carte.Motif := T_Motif'val(12) ;
         when others => null ;
      end case;
      
      return Carte;
   end Carte_Str2Carte;
   
   
   Function Unicite_cartes(Liste_carte : IN T_liste_cartes) return Boolean is
      Bool : Boolean := True;
   Begin
      for i in 1..Liste_carte.nbr_cartes-1 LOOP
         for j in i+1..Liste_carte.nbr_cartes LOOP
            if Liste_carte.cartes(i) = Liste_carte.cartes(j) THEN
               Bool := False;
            end IF;       
         end LOOP;
      end LOOP;   
      return Bool;
   End;
---------------------------
-- Manipulation de T_jeu --
---------------------------
   
   Procedure Set_BigBlind(jeu : OUT T_Jeu; BB : IN Natural) is
   begin
      jeu.big_blind:=BB;
   end;
   
   Procedure Set_SmallBlind(jeu : OUT T_Jeu; SB : IN Natural) is
   begin
      jeu.small_blind:=SB;
   end;
   
   Procedure Set_N_hand(jeu : OUT T_Jeu; N_hand : IN Positive) is
   begin
      jeu.N_hand:=N_hand;
   end;
   
   Procedure Set_Pot(jeu : OUT T_Jeu; Pot : IN Natural) is
   begin
      jeu.Pot:=Pot;
   end;
   
   Procedure Set_Amount_to_call(jeu : OUT T_Jeu; ATC : IN Natural) is
   begin
      jeu.Amount_to_call:=ATC;
   end;
   
   Procedure Set_Min_bet(jeu : OUT T_Jeu; MB: IN Natural) is
   begin
      jeu.Min_bet:=MB;
   end;
   
   Function Get_Amount_to_call(jeu : IN T_Jeu) return Natural is
   begin
      return jeu.Amount_to_call;
   end;
   
   Function Get_Pot(jeu : IN T_Jeu) return Natural is
   begin
      return jeu.Pot;
   end;
   
   Function Get_N_hand(jeu : IN T_Jeu) return Positive is
   begin
      return jeu.N_hand;
   end;
   
   Function Get_SmallBlind(jeu : IN T_Jeu) return Natural is
   begin
      return jeu.small_blind;
   end;
   
   Function Get_BigBlind(jeu : IN T_Jeu) return Natural is
   begin
      return jeu.big_blind;
   end;
   
   Function Get_Min_bet(jeu : IN T_Jeu) return Natural is
   begin
      return jeu.Min_bet;
   end;
   
   
-----------------------------
-- Manipulation des cartes --
-----------------------------
      
   Procedure Set_carte(carte : OUT T_Carte; motif : IN T_Motif; couleur : IN T_Couleur) is
   Begin
      carte.Couleur := couleur;
      carte.Motif := motif;
   end;
   
   Procedure Add_liste_carte(carte : IN T_Carte; liste_carte : IN OUT T_liste_cartes) is
   Begin
      if liste_carte.nbr_cartes + 1 > MAX_LISTE_CARTES THEN
         Put_Line(Standard_Error,"MAX_LISTE_CARTES est depasse");
      end if;
      liste_carte.nbr_cartes := liste_carte.nbr_cartes + 1;
      liste_carte.cartes(liste_carte.nbr_cartes) := carte;
   end;
   
   Procedure Set_liste_carte(carte : IN T_Carte; liste_carte : IN OUT T_liste_cartes; Index : IN Natural) is
   Begin
      liste_carte.cartes(Index) := carte;
      if Index > liste_carte.nbr_cartes and Index <= MAX_LISTE_CARTES THEN
         liste_carte.nbr_cartes := liste_carte.nbr_cartes + 1;
      end if;
   End;

   
   Function Init_liste_carte return T_liste_cartes is
      Liste_carte : T_liste_cartes;
   Begin
      Liste_carte.nbr_cartes := 0; -- Inutile mais evite le Warning a la compilation
      return Liste_carte;
   end;
   
   Function Get_nbr_liste_carte(liste_carte : IN T_liste_cartes) return Natural is
   Begin
      return liste_carte.nbr_cartes;
   end;
   
   Function Get_liste_carte(liste_carte : IN T_liste_cartes; index : IN Natural) return T_Carte is
   Begin
      if index > liste_carte.nbr_cartes THEN
         Put_Line(Standard_Error,"Appel d'une carte hors de la liste");
      end if;
      return liste_carte.cartes(index);
   end;
   
   Function Get_carte_motif(Carte : IN T_Carte) return T_Motif is
   Begin
      return Carte.Motif;
   end;
   
   Function Get_carte_couleur(Carte : IN T_Carte) return T_Couleur is
   Begin
      return Carte.Couleur;
   end;
   
   
   Function ">" (Carte_1 : IN T_Carte ; Carte_2 : IN T_Carte) return Boolean is
   Begin
      if T_Motif'Pos(Carte_1.Motif) > T_Motif'Pos(Carte_2.Motif) THEN
         return True;
      else
         return False;
      end if;
   end;
   
   Function "<" (Carte_1 : IN T_Carte ; Carte_2 : IN T_Carte) return Boolean is
   Begin
      if T_Motif'Pos(Carte_1.Motif) < T_Motif'Pos(Carte_2.Motif) THEN
         return True;
      else
         return False;
      end if;
   end;

   Function "=" (Carte_1 : IN T_Carte ; Carte_2 : IN T_Carte) return Boolean is
   Begin
      if T_Motif'Pos(Carte_1.Motif) = T_Motif'Pos(Carte_2.Motif) and T_Couleur'Pos(Carte_1.Couleur) = T_Couleur'Pos(Carte_2.Couleur) THEN
         return True;
      else
         return False;
      end if;
   end;
   
------------------------------
-- Manipulation de T_joueur --
------------------------------
   
   Procedure Set_stack(joueur : OUT T_joueur ; stack : IN Natural) is
   Begin
      joueur.Stack := stack;
   end;
   
   Procedure Set_joueur_main(joueur : OUT T_joueur ; main : IN T_liste_cartes) is
   Begin
      if main.nbr_cartes /= 2 THEN
         Put_Line(Standard_Error,"Main d'un joueur avec plus ou moin de 2 cartes");
      end if;
      joueur.Main := main;
   end;
   
   Procedure Set_joueur_button(joueur : OUT T_joueur; is_button : IN Boolean) is
   Begin
      joueur.Button := is_button;
   end;
   
   Procedure Set_joueur_move(joueur : OUT T_joueur; move : IN T_moves) is
   Begin
      joueur.move := move;
   end;

   Procedure Set_joueur_amount_move(joueur : OUT T_joueur; amount : IN Natural) is
   Begin
      joueur.amount_move := amount;
   end;
   
   
   
   Function Get_Stack(joueur : IN T_joueur) return Natural is
   Begin
      return joueur.Stack;
   end;
   
   Function Get_joueur_main(joueur : IN T_joueur) return T_liste_cartes is
   Begin
      return joueur.Main;
   end;
   
   Function Get_joueur_move(joueur : IN T_joueur) return T_moves is
   Begin
      return joueur.move;
   end;
   
   Function Is_button(joueur : IN T_joueur) return Boolean is
   Begin
      return joueur.Button;
   end;
   
   Function Get_joueur_amount_move(joueur : IN T_joueur) return Natural is
   Begin
      return joueur.amount_move;
   end;
   
   ----------------------
   -- Utiles aux tests --
   ----------------------
   
   procedure Affiche_carte(Carte : IN T_Carte) is
   Begin
      Put_Line(T_Motif'Image(Get_carte_motif(Carte)) & " de " & T_couleur'Image(Get_carte_couleur(Carte)));
   end;

   procedure Affiche_liste_carte(liste_carte : IN T_liste_cartes) is
   Begin
      for i in 1..Get_nbr_liste_carte(liste_carte) LOOP
         Affiche_carte(Get_liste_carte(liste_carte,i));
      end loop;
   end;
   
   procedure Affiche_jeu(jeu : IN T_Jeu) is
   Begin
      Put_Line("Blinds : " & Integer'Image(jeu.big_blind) & ";" & Integer'Image(jeu.small_blind));
      Put_Line("Num de main : " & Integer'Image(jeu.N_hand));
      Put_Line("Pot : " & Integer'Image(jeu.Pot));
      Put_Line("Amount_to_call : " & Integer'Image(jeu.Amount_to_call));
      Put_Line("Min_bet : " & Integer'Image(jeu.Min_bet));
   end;
   
   procedure Affiche_joueur(joueur : IN T_joueur) is
   Begin
      Put_Line("Stack : " & Integer'Image(joueur.Stack));
      Put_Line("Button : " & Boolean'Image(joueur.Button));
      Put_Line("Cartes du joueur : ");
      Affiche_liste_carte(joueur.Main);
      Put_Line("Move : " & T_moves'Image(joueur.move) & Natural'Image(joueur.amount_move));
   End;
   
end Modelisation_poker;
