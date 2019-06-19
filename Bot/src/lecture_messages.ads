WITH Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling, Ada.Characters.Handling, Modelisation_poker; 
USE  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling, Ada.Characters.Handling, Modelisation_poker;

package lecture_messages is -- DONE & CHECKED
   
   ---------------------------------------
   ---------------- TYPES ----------------
   ---------------------------------------
 
   -- CHECKED -- Tous les mots composant les messages
   Type T_mots_clefs_1 is (action, update_game, update_hand);
   Type T_mots_clefs_2 is (button, stack, small_blind, big_blind, hand, table, pot, amount_to_call, min_bet, move, win); 
   Type T_mots_clefs_3 is (self, other);

   
   MAX_MOT_MESSAGE : Constant Natural := 10;
   MAX_CHAR_CHAINE : Constant Natural := 100; -- Permet de stocker les messages entiers, les mots ... 
   Type T_chaine is private;
   Type T_message is private; -- stock le message sous forme de chaine et comme liste de mots clefs
   
   ---------------------------------------
   ---------- PROCEDURE/FUNCTION ---------
   ---------------------------------------
   
   -- Jouer
   -- E/ Move : T_move, Amount_move
   -- Necessite : Amount_move n'est lue que dans le cas ou move = Bet
   -- Entraine : Ecrit au Launcher l'action renseigne et met a jour les informations
   procedure Jouer(move : IN T_moves ; Amount_move : IN Natural ; Self : OUT T_joueur ; Other : IN T_joueur );
   
   -- Analyse des messages :
   
   -- est_mots_clefs_1
   -- E/ Mot : T_chaine
   -- Necessite : Null
   -- S/ Boolean
   -- Entraine : True si le mot appartient T_mot_clef, False sinon
   function est_mots_clefs_1(mot_clef : IN T_chaine) return Boolean;
   
   -- other_moves
   -- E/ Message launcher
   -- Necessite : message decompose
   -- S/ Boolean
   -- Entraine : True si le message indique les cartes de l'adversaire, False sinon
   function other_cartes_update(message : IN T_message) return Boolean;
   
   -- lecture_cartes
   -- E/ Texte : T_chaine
   -- Necessite : Une chaine de cartes issues du Launcher (ex : "Ks,Th,4d")
   -- S/ Liste de carte : T_liste_cartes
   -- Entraine : La liste de cartes associee au texte
   function lecture_cartes(cartes_str : IN T_chaine) return T_liste_cartes; -- CHECKED test_lecture_message
   
   -- Get
   -- E/ Lecture console d'un message du Launcher
   -- S/ Message : T_message
   -- Entraine : Message lue et decompose, pret pour Update_data
   procedure Get(Message : OUT T_message);
   
   -- Update_data
   -- E/ Message : T_message
   -- Necessite : Le message est issue du Launcher
   -- S/ Table : T_liste_cartes ; Infos de la partie : T_jeu ; 2 joueures : T_joueur
   -- Entraine : Mise a jour de l'etat de la partie en fonction du message
   procedure Update_data(message : IN T_message ; Table : OUT T_liste_cartes ; info_partie : Out T_jeu ; J_Self : Out T_joueur ; J_Other : Out T_joueur); -- CHECKED test_maj_bot J_Other : Out T_joueur); -- NON CHECKED
   
   
   -- Manipulation de T_chaine
   
   Procedure Set_chaine(Chaine : OUT T_chaine ; line : IN String ; line_length : IN Integer);

   Function Get_chaine_line(Chaine : IN T_chaine) return String;
   Function Get_chaine_len(Chaine : IN T_chaine) return Natural;
   
   procedure get_line(Chaine : OUT T_chaine);   
   
   
   -- Manipulation de T_message
   
   -- Entree : Un message T_message et une chaine lue depuis le Launcher
   -- Sortie : Le message comporte le message brut mais aussi le message decompose
   -- La mise a jour de la liste de mots est automatise pour eviter toute incoherence au sein d'un message
   procedure Set_message(Message : OUT T_message; Chaine : IN T_chaine);

   function Get_message_entier(Message : IN T_message) return T_chaine;
   function Get_message_mot(Message : IN T_message ; Index : IN Natural) Return T_chaine;
   function Get_message_nbr_mot(Message : IN T_message) return Natural;
   
   
private
   
   -- Permet de stocker les mots et les messages
   Type T_chaine is record -- CHECKED
      line : string(1..MAX_CHAR_CHAINE); 
      line_length : Natural :=0;
   end record;
   
   -- Permet de stocker les messages decompose
   Type T_tab_mot is Array (1..MAX_MOT_MESSAGE) of T_chaine;
   
   Type T_message is record
      total : T_chaine;
      decompose : T_tab_mot; -- suffit a stocker toutes les strings composant les messages (separe par espace)
      nbr_mot : Natural := 0;
   end record;
   
   -- Utile a l'implementation de Update_data
   -- Met a jour les donnees de jeu et des joueurs pour un certain message deja decompose commencant par update_game
   procedure lecture_update_game(message : IN T_message ; info_partie : Out T_jeu ; J_Self : Out T_joueur ; J_Other : Out T_joueur ; Table : OUT T_liste_cartes); -- NON CHECKED
   
   -- Met a jour les donnees de jeu et des joueurs pour un certain message deja decompose commencant par update_hand
   procedure lecture_update_hand(message : IN T_message ; Table : OUT T_liste_cartes ; info_partie : Out T_jeu ; J_Self : Out T_joueur ; J_Other : Out T_joueur ); -- NON CHECKED
   
   -- Decoupe les messages selon les espaces et stock chques mots dans le tableau message.decompose
   procedure decompose_message(message : IN OUT T_message); -- CHECKED test_lecture_message
   
   procedure update_stack(move : IN T_moves ; amount_move_launcher : IN Natural ; J_mover : OUT T_joueur ; J_idle : IN T_joueur);
   
end lecture_messages;
