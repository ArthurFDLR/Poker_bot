WITH ada.text_io, Modelisation_poker, lecture_messages, Analyse_cartes, strategie_adversaire, Evaluation_main;
USE  ada.text_io, Modelisation_poker, lecture_messages, Analyse_cartes, strategie_adversaire, Evaluation_main;

procedure bot is

   message : T_message;
   info_partie : T_jeu;
   Self : T_joueur;
   Other : T_joueur;
   Table : T_liste_cartes;
   Profil_adversaire : T_profil_adversaire := Suisse;
   Puissance_main_self : Natural :=0;

begin
   while not End_Of_File loop   -- Loop infini de jeu

      Get(message);
      Update_data(message     => message,
                  Table       => Table,
                  info_partie => info_partie,
                  J_Self      => Self,
                  J_Other     => Other);

      if Get_Action_needed(info_partie) THEN -- Si le launcher attend une réponse


         Puissance_main_self := Get_puissance_main(Table        => Table,
                                                   Self         => Self,
                                                   Limite_duree => Get_time_to_play(info_partie)*0.8);

         Think_Then_Play(force_main => Puissance_main_self,
                         profil_adv => Profil_adversaire,
                         jeu        => info_partie,
                         self       => Self,
                         other      => Other);

         Set_Action_needed(info_partie, False);
      end if;
   end loop;
end;

