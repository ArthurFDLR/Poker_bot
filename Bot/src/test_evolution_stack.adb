With ada.Text_IO, Analyse_cartes, Evaluation_main, lecture_messages, Modelisation_poker;
Use  ada.Text_IO, Analyse_cartes, Evaluation_main, lecture_messages, Modelisation_poker;

procedure test_evolution_stack is
   Message_in : T_message;
   table_in : T_liste_cartes;
   info : T_Jeu;
   Jself : T_joueur;
   Jother : T_joueur;
begin
   for i in 1..10 LOOP
      get(Message_in);
      if Get_chaine_line(Get_message_entier(Message_in)) = "action" THEN
         Jouer(move        => call,
               Amount_move => 0,
               Self        => Jself,
               Other       => Jother);
         Affiche_joueur(Jself);
         Affiche_joueur(Jother);
      else
         Update_data(message     => Message_in,
                     Table       => table_in,
                     info_partie => info,
                     J_Self      => Jself,
                     J_Other     => Jother);
         Affiche_joueur(Jself);
         Affiche_joueur(Jother);
      end if;
   end loop;
end test_evolution_stack;
