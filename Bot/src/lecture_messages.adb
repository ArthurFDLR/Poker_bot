package body lecture_messages is
   
   procedure Jouer(move : IN T_moves ; Amount_move : IN Natural ; Self : OUT T_joueur ; Other : IN T_joueur ) is
   Begin
      if move = T_moves'Val(3) THEN
         update_stack(move                 => move,
                      amount_move_launcher => Amount_move,
                      J_mover              => Self,
                      J_idle               => Other);
         Put_Line(T_moves'Image(move) & Integer'Image(Amount_move));
      else
         update_stack(move                 => move,
                      amount_move_launcher => 0,
                      J_mover              => Self,
                      J_idle               => Other);

         Put_Line(To_Lower(T_moves'Image(move)));
      end if;
      Set_joueur_move(Self,move);
   end;
   
   function est_mots_clefs_1(mot_clef : IN T_chaine) return Boolean is
      bool : Boolean := False;
   Begin
      for mot in T_mots_clefs_1'First..T_mots_clefs_1'Last loop --Comparaison avec tous les elements definis dans T_mots_clefs
         if T_mots_clefs_1'Image(mot) = To_Upper(mot_clef.line(1..mot_clef.line_length)) then
            bool := True;
         end if;
      end loop;
      return bool;
   end est_mots_clefs_1;
   
   function other_cartes_update(message : IN T_message) return Boolean is
      bool : Boolean := False;
   Begin
      if T_mots_clefs_2'Value(Get_chaine_line(Get_message_mot(message,2))) = T_mots_clefs_2'Val(4) and T_mots_clefs_2'Value(Get_chaine_line(Get_message_mot(message,3))) = T_mots_clefs_2'Val(1) THEN
         bool := True;
      end if;
      return bool;
   end;
   
   
   procedure decompose_message(message : IN OUT T_message) is
      nbr_mot : Integer := 1;
      nbr_lettre : Integer :=0;
   Begin
      message.total.line(message.total.line_length+1..message.total.line_length+1) := " "; -- Pour valider dernier mot
      for ilettre in 1..message.total.line_length+1 loop
         if message.total.line(ilettre..ilettre) /= " "  -- ajouter la lettre au mot courant
         then
            nbr_lettre := nbr_lettre + 1;
            message.decompose(nbr_mot).line(nbr_lettre..nbr_lettre) := message.total.line(ilettre..ilettre);
         else
            message.decompose(nbr_mot).line_length := nbr_lettre; --Passer a un nouveau mot
            nbr_lettre := 0;
            nbr_mot := nbr_mot + 1;
         end if;
      end loop;
      message.nbr_mot := nbr_mot-1; --eliminer derniere entree en trop
   end decompose_message;
   
   function lecture_cartes(cartes_str : IN T_chaine) return T_liste_cartes is
      nbr_cartes : Integer := 1;
      nbr_lettre : Integer := 0;
      liste_cartes_str : T_tab_mot;
      liste_cartes : T_liste_cartes;
   Begin
      for ilettre in 1..cartes_str.line_length loop -- Decomposition de la liste en plusieures strigs par des , cf fonction precedente
         if cartes_str.line(ilettre..ilettre) /= ","  -- ajouter la lettre au mot courant
         then
            nbr_lettre := nbr_lettre + 1;
            liste_cartes_str(nbr_cartes).line(nbr_lettre..nbr_lettre) := cartes_str.line(ilettre..ilettre);
         else
            liste_cartes_str(nbr_cartes).line_length := nbr_lettre; --Passer a un nouveau mot
            nbr_lettre := 0;
            nbr_cartes := nbr_cartes + 1;
         end if;
      end loop;
      liste_cartes_str(nbr_cartes).line_length := nbr_lettre; --Valider dernier mot
      nbr_lettre := 0;
      nbr_cartes := nbr_cartes + 1;
      
      for icarte in 1..(nbr_cartes - 1) loop --Conversion au type T_cartes
         Add_liste_carte(carte       => Carte_Str2Carte (liste_cartes_str(icarte).line(1..liste_cartes_str(icarte).line_length)),
                         liste_carte => liste_cartes);
      end loop;
                                                         
      return liste_cartes;
   end lecture_cartes;

   procedure lecture_update_game(message : IN T_message ; info_partie : Out T_jeu ; J_Self : Out T_joueur ; J_Other : Out T_joueur ; Table : OUT T_liste_cartes) is
   Begin
      case T_mots_clefs_2'value(message.decompose(2).line(1..message.decompose(2).line_length)) is
         
         when T_mots_clefs_2'Val(0) => --button
            case T_mots_clefs_3'value(message.decompose(3).line(1..message.decompose(3).line_length)) is
               when T_mots_clefs_3'Val(0) => --self
                  Set_joueur_button(J_Self , True);
                  Set_joueur_button(J_Other , False);
                  
                  Set_joueur_amount_move(J_Self, Get_SmallBlind(info_partie)); --stock les actions de blind des joueurs
                  Set_joueur_amount_move(J_Other, Get_BigBlind(info_partie));
                  Set_stack(J_Self, Integer'Max(Get_Stack(J_Self) - Get_joueur_amount_move(J_Self),0));
                  Set_stack(J_Other, Integer'Max(Get_Stack(J_Other) - Get_joueur_amount_move(J_Other),0));
                  
                  
               when T_mots_clefs_3'Val(1) => --other
                  Set_joueur_button(J_Self , False);
                  Set_joueur_button(J_Other , True);
                  
                  Set_joueur_amount_move(J_Other, Get_SmallBlind(info_partie)); --stock les actions de blind des joueurs
                  Set_joueur_amount_move(J_Self, Get_BigBlind(info_partie));
                  Set_stack(J_Self, Integer'Max(Get_Stack(J_Self) - Get_joueur_amount_move(J_Self),0));
                  Set_stack(J_Other, Integer'Max(Get_Stack(J_Other) - Get_joueur_amount_move(J_Other),0));
            end case;
            
         when T_mots_clefs_2'Val(1) => --stack
            case T_mots_clefs_3'value(message.decompose(3).line(1..message.decompose(3).line_length)) is 
               when T_mots_clefs_3'Val(0) =>   -- Utilisation de 'val pour ne pas confondre les self et other des differents types enumere
                  Set_stack(J_Self,Natural'value(message.decompose(4).line(1..message.decompose(4).line_length)));
               when T_mots_clefs_3'Val(1) =>
                  Set_stack(J_Other,Natural'value(message.decompose(4).line(1..message.decompose(4).line_length)));
            end case;
         
         when T_mots_clefs_2'Val(2) => --small_blind
            Set_SmallBlind(info_partie, Natural'value(message.decompose(3).line(1..message.decompose(3).line_length)));
         
         when T_mots_clefs_2'Val(3) => --big_blind
            Set_BigBlind(info_partie, Natural'value(message.decompose(3).line(1..message.decompose(3).line_length)));
         
         when T_mots_clefs_2'Val(4) => --hand
            Set_N_hand(info_partie,Positive'value(message.decompose(3).line(1..message.decompose(3).line_length)));
            Table := Init_liste_carte; -- Si on est à une nouvelle main on reinitialise la table et les mains
            Set_joueur_main(J_Self, Init_liste_carte);
            Set_joueur_main(J_Other, Init_liste_carte);

         when others => null; --Afin de ne pas prendre en compte les mots appartenant a T_mots_clefs_2 decoulant de update_hand
         
      end case;
   End lecture_update_game;

   procedure lecture_update_hand(message : IN T_message ; Table : OUT T_liste_cartes ; info_partie : Out T_jeu ; J_Self : Out T_joueur ; J_Other : Out T_joueur ) is
   Begin
      case T_mots_clefs_2'value(message.decompose(2).line(1..message.decompose(2).line_length)) is
         
         when T_mots_clefs_2'Val(4) => --hand
            case T_mots_clefs_3'value(message.decompose(3).line(1..message.decompose(3).line_length)) is -- Remplir les cartes du joueur ...
               
            when T_mots_clefs_3'Val(0) => --...self
               Set_joueur_main(joueur => J_Self,
                               main   => lecture_cartes(message.decompose(4)));
            when T_mots_clefs_3'Val(1) => --...other
               Set_joueur_main(joueur => J_Other,
                               main   => lecture_cartes(message.decompose(4)));
            end case;
            
         when T_mots_clefs_2'Val(5) => --table
            Table := lecture_cartes(message.decompose(3));--remplir les cartes de la table

         when T_mots_clefs_2'Val(6) => --pot
            Set_Pot(info_partie , Natural'Value(message.decompose(3).line(1..message.decompose(3).line_length)));

         when T_mots_clefs_2'Val(7) => --amount_to_call
            Set_Amount_to_call(info_partie , Natural'Value(message.decompose(3).line(1..message.decompose(3).line_length)));

         when T_mots_clefs_2'Val(8) => --min_bet
            Set_Min_bet(info_partie , Natural'Value(message.decompose(3).line(1..message.decompose(3).line_length)));
         
            -- OLD me : "CAS NON ETUDIE POUR L'INSTANT, potentiellement utile si developpement d'une strategie plus complexe"
            -- NEW me : "Le complexe c'est maintenant"
         when T_mots_clefs_2'Val(9) => --move
            
            case T_mots_clefs_3'value(message.decompose(3).line(1..message.decompose(3).line_length)) is
            when T_mots_clefs_3'Val(0) => --...self
               Set_joueur_move(joueur => J_Self,
                               move   => T_moves'Value(message.decompose(4).line(1..message.decompose(4).line_length)));
               
               if T_moves'value(message.decompose(4).line(1..message.decompose(4).line_length)) = T_moves'Val(3) THEN -- Si le move est bet
                  update_stack(move        => T_moves'Value(message.decompose(4).line(1..message.decompose(4).line_length)),
                               amount_move_launcher => Natural'Value(message.decompose(5).line(1..message.decompose(5).line_length)),
                               J_mover      => J_Self,
                               J_idle     => J_Other);
               else
                  update_stack(move        => T_moves'Value(message.decompose(4).line(1..message.decompose(4).line_length)),
                               amount_move_launcher => 0,
                               J_mover      => J_Self,
                               J_idle     => J_Other);
               end if;
               
            when T_mots_clefs_3'Val(1) => --...other
               Set_joueur_move(joueur => J_Other,
                               move   => T_moves'Value(message.decompose(4).line(1..message.decompose(4).line_length)));
               if T_moves'value(message.decompose(4).line(1..message.decompose(4).line_length)) = T_moves'Val(3) THEN -- Si le move est bet
                  update_stack(move        => T_moves'Value(message.decompose(4).line(1..message.decompose(4).line_length)),
                               amount_move_launcher => Natural'Value(message.decompose(5).line(1..message.decompose(5).line_length)),
                               J_mover      => J_Other,
                               J_idle     => J_Self);
               else
                  update_stack(move        => T_moves'Value(message.decompose(4).line(1..message.decompose(4).line_length)),
                               amount_move_launcher => 0,
                               J_mover      => J_Other,
                               J_idle     => J_Self);
               end if;
                            
            end case;
            
         when T_mots_clefs_2'Val(10) => --win
            null;

         when others => null; --Afin de ne pas prendre en compte les mots appartenant a T_mots_clefs_2 decoulant de update_hand
         
      end case;
   End lecture_update_hand;
   
   procedure update_stack(move : IN T_moves ; amount_move_launcher : IN Natural ; J_mover : OUT T_joueur ; J_idle : IN T_joueur) is
   Begin
      case move is
         when T_moves'Val(0) => -- fold
            Set_joueur_amount_move(J_mover,0);
         when T_moves'Val(1) => -- check
            Set_joueur_amount_move(J_mover,0);
         when T_moves'Val(2) => -- call
            Set_joueur_amount_move(J_mover,Get_joueur_amount_move(J_idle));
         when T_moves'Val(3) => -- bet
            if Get_joueur_move(J_idle) = T_moves'Val(3) THEN
               Set_joueur_amount_move(J_mover,Get_joueur_amount_move(J_idle) + amount_move_launcher);
            else
               Set_joueur_amount_move(J_mover,amount_move_launcher);
            end if;
      end case;
      
      Set_stack(J_mover, Integer'Max(0,Get_Stack(J_mover) - Get_joueur_amount_move(J_mover)));
   end;
   
   procedure Update_data(message : IN T_message ; Table : OUT T_liste_cartes ; info_partie : Out T_jeu ; J_Self : Out T_joueur ; J_Other : Out T_joueur) is
   Begin
      if est_mots_clefs_1(Get_message_mot(message,1)) THEN
         
         case T_mots_clefs_1'value(message.decompose(1).line(1..message.decompose(1).line_length)) is -- Determination du premier mot du message
         When T_mots_clefs_1'Val(1) => -- Update_game : on met a jour les infos
            lecture_update_game(message, info_partie, J_Self, J_Other, Table);
            
         When T_mots_clefs_1'Val(2) => -- Update_hand : on met a jour les infos
            lecture_update_hand(message, Table, info_partie, J_Self, J_Other);
            
         When T_mots_clefs_1'Val(0) => -- Action
            Set_Action_needed(info_partie,True);
            Set_time_to_play(info_partie, Float'Value(Get_chaine_line(Get_message_mot(message,2))));
         end case;
      else
         Put_Line(Standard_Error,"Lecture d'un message non pris en charge : " & Get_chaine_line(Get_message_entier(message)));
      end if;
      
   end;
   
   -- Manipulation de T_chaine
   
   Procedure Set_chaine(Chaine : OUT T_chaine ; line : IN String ; line_length : IN Integer) is
   Begin
      if line_length > MAX_CHAR_CHAINE THEN
         Put_Line(Standard_Error, "Stockage d'une chaine excedant la taille maximale");
      end if;
      Chaine.line(1..line_length) := line;
      Chaine.line_length := line_length;
   end;
   
   procedure get_line(Chaine : OUT T_chaine) is
   Begin
      get_line(Chaine.line,Chaine.line_length);
   end;
   

   Function Get_chaine_line(Chaine : IN T_chaine) return String is
   Begin
      Return Chaine.line(1..Chaine.line_length);
   end;
   
   Function Get_chaine_len(Chaine : IN T_chaine) return Natural is
   Begin
      Return Chaine.line_length;
   End;

   -- Manipulation T_message
   
   procedure Set_message(Message : OUT T_message; Chaine : IN T_chaine) is
   Begin
      Message.total := Chaine;
      decompose_message(Message);
   end;
     
   procedure Get(Message : OUT T_message) is
   Begin
      get_line(message.total.line, message.total.line_length);
      decompose_message(message);
   end;
   
   function Get_message_entier(Message : IN T_message) return T_chaine is
   Begin
      return Message.total;
   end;
   
   function Get_message_mot(Message : IN T_message ; Index : IN Natural) Return T_chaine is
   Begin
      if Index > MAX_MOT_MESSAGE THEN
         Put_Line(Standard_Error, "Stockage d'un message excedant la taille maximale");
      end if;
      return Message.decompose(Index);
   end;
   
   function Get_message_nbr_mot(Message : IN T_message) return Natural is
   Begin
      return Message.nbr_mot;
   end;
   
end lecture_messages;
