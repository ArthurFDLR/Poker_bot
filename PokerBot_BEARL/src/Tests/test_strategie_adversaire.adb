with lecture_messages, strategie_adversaire, Modelisation_poker; use lecture_messages, strategie_adversaire, Modelisation_poker;

procedure Test_strategie_adversaire is
   table : T_liste_cartes;
   info_partie : T_Jeu;
   self,other : T_joueur;
   chaine_message : T_chaine;
   Message : T_message;
   stockage : stockage_tours;
begin
   
   Set_chaine(Chaine      => chaine_message,
              line        => "settings hands_per_level 10",
              line_length => 27);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "settings timebank 2000",
              line_length => 22);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "settings time_per_move 500",
              line_length => 26);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "update_game hand 1",
              line_length => 18);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "update_game small_blind 10",
              line_length => 26);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "update_game big_blind 20",
              line_length => 24);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "update_game button self",
              line_length => 23);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "update_game stack other 1000",
              line_length => 28);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   Set_chaine(Chaine      => chaine_message,
              line        => "update_game stack self 1000",
              line_length => 27);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   
  Set_chaine(Chaine      => chaine_message,
              line        => "update_hand hand self 6h,9s",
              line_length => 27);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
     Set_chaine(Chaine      => chaine_message,
              line        => "update_hand pot 30",
              line_length => 18);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   
     Set_chaine(Chaine      => chaine_message,
              line        => "update_hand amount_to_call 10",
              line_length => 29);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   
   
     Set_chaine(Chaine      => chaine_message,
              line        => "update_hand min_bet 20",
              line_length => 22);
   
   Set_message(Message => message,
               Chaine  => chaine_message);
   
   Update_data(message     => message,
               Table       => table,
               info_partie => info_partie,
               J_Self      => self,
               J_Other     => other)  ;
   
   --Affiche_jeu(info_partie);
   stocke_tour(jeu      => info_partie,
               self     => self,
               other    => other,
               table    => table,
               stockage => stockage);
   affiche_stockage_tours(stockage => stockage,
                          index    => 1);
     
    
   
   
end Test_strategie_adversaire;
