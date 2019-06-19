with Ada.Numerics.Discrete_Random; -- cf. Generation_liste_int

package body Evaluation_main is
   
   
   function Generation_liste_int return T_liste_52int is
      package Int52_alea is new Ada.Numerics.Discrete_Random (T_Numero);
      use Int52_alea;
      
      Int_generator : Generator;
      liste_int : T_liste_52int;
      nbr_echange : Integer := 52;
   Begin
      Reset(Int_generator); -- Random(Int_generator)
      for i in 1..52 LOOP 
         liste_int(i) := T_Numero(i);
      end loop;
      for i in 1..nbr_echange LOOP
         Echange_elem_liste(liste => liste_int,
                            i     => i,
                            j     => Integer(Random(Int_generator)));
      end loop;
      return liste_int;
   end;
   
   
   procedure Echange_elem_liste(liste : IN OUT T_liste_52int ; i : IN Integer ; j : IN Integer) is
      tmp : T_Numero;
   Begin
      tmp := liste(i);
      liste(i) := liste(j);
      liste(j) := tmp;
   end;
   
   
   function Association_nbr_carte(nbr : IN T_Numero) return T_Carte is
      carte : T_Carte;
   Begin
      Set_carte(carte   => carte,
                motif   => T_Motif'Val(Integer(nbr - 1) rem 13),
                couleur => T_Couleur'Val(Integer(nbr - 1)/13));
      return carte;
   end;
   
   function Generation_liste_carte return T_liste_52cartes is
      liste_52int : T_liste_52int;
      liste_52cartes : T_liste_52cartes;
   Begin
      liste_52int := Generation_liste_int;
      for i in 1..52 LOOP
         liste_52cartes(i) := Association_nbr_carte(liste_52int(i));
      end loop;
      return liste_52cartes;
   end;
   

   function Self_gagne(Combinaison_self : IN T_combinaison; Self : IN T_joueur ; Other : IN T_joueur ; Table : IN T_liste_cartes) return Boolean is
      Self_win : Boolean := False;
      Combinaison_other : T_combinaison;
      Best_carte_self, Best_carte_other : T_Carte;
   Begin
      Combinaison_other := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Other),Table));
      if Combinaison_self > Combinaison_other THEN
         Self_win := True;
      elsif Combinaison_self = Combinaison_other THEN
         
         -- Selection de la meilleure carte dans la main de self qui ne forme pas la potentielle combinaison
         if Get_liste_carte(Get_joueur_main(Self),1) > Get_liste_carte(Get_joueur_main(Self),2) and Get_carte_motif(Get_liste_carte(Get_joueur_main(Self),1)) /= Get_motif1_combinaison(Combinaison_self) THEN
            Best_carte_self := Get_liste_carte(Get_joueur_main(Self),1);
         elsif Get_liste_carte(Get_joueur_main(Self),2) > Get_liste_carte(Get_joueur_main(Self),1) and Get_carte_motif(Get_liste_carte(Get_joueur_main(Self),2)) /= Get_motif1_combinaison(Combinaison_self) THEN
            Best_carte_self := Get_liste_carte(Get_joueur_main(Self),2);
         end if;
         
         -- Selection de la meilleure carte dans la main de other qui ne forme pas la potentielle combinaison
         if Get_liste_carte(Get_joueur_main(Other),1) > Get_liste_carte(Get_joueur_main(Other),2) and Get_carte_motif(Get_liste_carte(Get_joueur_main(Other),1)) /= Get_motif1_combinaison(Combinaison_other) THEN
            Best_carte_other := Get_liste_carte(Get_joueur_main(Self),1);
         elsif Get_liste_carte(Get_joueur_main(Other),2) > Get_liste_carte(Get_joueur_main(Other),1) and Get_carte_motif(Get_liste_carte(Get_joueur_main(Other),2)) /= Get_motif1_combinaison(Combinaison_other) THEN
            Best_carte_other := Get_liste_carte(Get_joueur_main(Other),2);
         end if;
         
         if Best_carte_self > Best_carte_other THEN
            Self_win := True;
         end if;
      end if;
      return Self_win;
   End;
   
   function pourcentage_gagne_PostFlop_NoLimit(Table : IN T_liste_cartes ; Self : T_joueur) return Natural is
      Liste_alea_1,Liste_alea_2,Liste_alea_3,Liste_alea_4 : T_liste_52cartes;
      other_tmp : T_joueur;
      main_tmp, Table_tmp : T_liste_cartes;
      nbr_simu,nbr_gagne : Natural := 0;
      Combinaison_self : T_combinaison;
   Begin
      if Get_nbr_liste_carte(Table) = 3 THEN -- Si on connait 3 cartes de la table
         
         Liste_alea_1 := Generation_liste_carte;
         Liste_alea_2 := Generation_liste_carte;
         Liste_alea_3 := Generation_liste_carte;
         Liste_alea_4 := Generation_liste_carte;
         Combinaison_self := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Self),Table));
         
         Table_tmp := Table;
         for i in 1..52 LOOP
            for j in 1..52 LOOP
               for k in 1..52 LOOP
                  for l in 1..52 LOOP
                     
                     Set_liste_carte(Liste_alea_1(i), main_tmp,1);
                     Set_liste_carte(Liste_alea_2(j), main_tmp,2);
                     Set_liste_carte(Liste_alea_3(k), Table_tmp,4);
                     Set_liste_carte(Liste_alea_4(l), Table_tmp,5);
                     
                     if Unicite_cartes(concatenation_cartes(main_tmp, concatenation_cartes(Get_joueur_main(Self),Table_tmp))) THEN
                        nbr_simu := nbr_simu + 1;
                        Set_joueur_main(other_tmp, main_tmp);
                        if Self_gagne(Combinaison_self,self,other_tmp,Table_tmp) THEN
                           nbr_gagne := nbr_gagne + 1;
                        end if;
                     end if;
                     
                  End LOOP;
               End LOOP;
            end LOOP;
         End LOOP;
         
      elsif  Get_nbr_liste_carte(Table) = 4 THEN -- Si on connait 4 cartes de la table 
         Liste_alea_1 := Generation_liste_carte;
         Liste_alea_2 := Generation_liste_carte;
         Liste_alea_3 := Generation_liste_carte;
         Combinaison_self := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Self),Table));
         Table_tmp := Table;
         for i in 1..52 LOOP
            for j in 1..52 LOOP
               for k in 1..52 LOOP

                  Set_liste_carte(Liste_alea_1(i), main_tmp,1);
                  Set_liste_carte(Liste_alea_2(j), main_tmp,2);
                  Set_liste_carte(Liste_alea_3(k), Table_tmp,5);
                     
                  if Unicite_cartes(concatenation_cartes(main_tmp, concatenation_cartes(Get_joueur_main(Self),Table_tmp))) THEN
                     nbr_simu := nbr_simu + 1;
                     Set_joueur_main(other_tmp, main_tmp);
                     if Self_gagne(Combinaison_self,self,other_tmp,Table_tmp) THEN
                        nbr_gagne := nbr_gagne + 1;
                     end if;
                  end if;
               End LOOP;
            end LOOP;
         End LOOP;
         
      elsif Get_nbr_liste_carte(Table) = 5 THEN -- Si on connait les 5 cartes de la table
         Liste_alea_1 := Generation_liste_carte;
         Liste_alea_2 := Generation_liste_carte;
         Combinaison_self := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Self),Table));
      
         for i in 1..52 LOOP
            for j in 1..52 LOOP
               Set_liste_carte(Liste_alea_1(i), main_tmp,1);
               Set_liste_carte(Liste_alea_2(j), main_tmp,2);
            
               if Unicite_cartes(concatenation_cartes(main_tmp, concatenation_cartes(Get_joueur_main(Self),Table))) THEN
                  nbr_simu := nbr_simu + 1;
                  Set_joueur_main(other_tmp, main_tmp);
                  if Self_gagne(Combinaison_self,self,other_tmp,Table) THEN
                     nbr_gagne := nbr_gagne + 1;
                  end if;
               end if;
            End LOOP;
         End LOOP;
      end if;
      
      return (nbr_gagne*100)/nbr_simu;
   End;

   function pourcentage_gagne_PostFlop_TimeLimited(Table : IN T_liste_cartes ; Self : T_joueur ; Limite_duree : IN Float) return Natural is
      Liste_alea_1,Liste_alea_2,Liste_alea_3,Liste_alea_4 : T_liste_52cartes;
      other_tmp : T_joueur;
      main_tmp, Table_tmp : T_liste_cartes;
      nbr_simu,nbr_gagne : Natural := 0;
      Combinaison_self : T_combinaison;
      Temps_init : time;
      Flag_inverse : Boolean := True;
   Begin
      Temps_init := Clock;
      
      
      if Get_nbr_liste_carte(Table) = 3 THEN -- Si on connait 3 cartes de la table
         
         Liste_alea_1 := Generation_liste_carte;
         Liste_alea_2 := Generation_liste_carte;
         Liste_alea_3 := Generation_liste_carte;
         Liste_alea_4 := Generation_liste_carte;
         Combinaison_self := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Self),Table));
         
         Table_tmp := Table;
         
         Cycle_calcul_3carte :
         for i in 1..52 LOOP
            for j in 1..52 LOOP
               for k in 1..52 LOOP
                  for l in 1..52 LOOP
                     IF Flag_inverse THEN
                        Set_liste_carte(Liste_alea_1(i), main_tmp,1);
                        Set_liste_carte(Liste_alea_2(j), main_tmp,2);
                        Set_liste_carte(Liste_alea_3(k), Table_tmp,4);
                        Set_liste_carte(Liste_alea_4(l), Table_tmp,5);
                     ELSE
                        Set_liste_carte(Liste_alea_1(53-l), main_tmp,1);
                        Set_liste_carte(Liste_alea_2(53-k), main_tmp,2);
                        Set_liste_carte(Liste_alea_3(53-j), Table_tmp,4);
                        Set_liste_carte(Liste_alea_4(53-i), Table_tmp,5);  
                     END IF;
                     Flag_inverse := NOT Flag_inverse;
                   
                     IF Unicite_cartes(concatenation_cartes(main_tmp, concatenation_cartes(Get_joueur_main(Self),Table_tmp))) THEN
                        nbr_simu := nbr_simu + 1;
                        Set_joueur_main(other_tmp, main_tmp);
                        if Self_gagne(Combinaison_self,self,other_tmp,Table_tmp) THEN
                           nbr_gagne := nbr_gagne + 1;
                        end if;
                     end if;
                     
                     exit Cycle_calcul_3carte when (Float(Clock-Temps_init)>Limite_duree);
                     
                  End LOOP;
               End LOOP;
            end LOOP;
         End LOOP Cycle_calcul_3carte;
         
      elsif  Get_nbr_liste_carte(Table) = 4 THEN -- Si on connait 4 cartes de la table 
         Liste_alea_1 := Generation_liste_carte;
         Liste_alea_2 := Generation_liste_carte;
         Liste_alea_3 := Generation_liste_carte;
         Combinaison_self := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Self),Table));
         Table_tmp := Table;
         
         Cycle_calcul_4carte :
         for i in 1..52 LOOP
            for j in 1..52 LOOP
               for k in 1..52 LOOP

                  Set_liste_carte(Liste_alea_1(i), main_tmp,1);
                  Set_liste_carte(Liste_alea_2(j), main_tmp,2);
                  Set_liste_carte(Liste_alea_3(k), Table_tmp,5);
                     
                  if Unicite_cartes(concatenation_cartes(main_tmp, concatenation_cartes(Get_joueur_main(Self),Table_tmp))) THEN
                     nbr_simu := nbr_simu + 1;
                     Set_joueur_main(other_tmp, main_tmp);
                     if Self_gagne(Combinaison_self,self,other_tmp,Table_tmp) THEN
                        nbr_gagne := nbr_gagne + 1;
                     end if;
                  end if;
                  
                  exit Cycle_calcul_4carte when (Float(Clock-Temps_init)>Limite_duree);
                  
               End LOOP;
            end LOOP;
         End LOOP Cycle_calcul_4carte;
         
      elsif Get_nbr_liste_carte(Table) = 5 THEN -- Si on connait les 5 cartes de la table
         Liste_alea_1 := Generation_liste_carte;
         Liste_alea_2 := Generation_liste_carte;
         Combinaison_self := detecte_meilleure_combinaison(concatenation_cartes(Get_joueur_main(Self),Table));
      
         Cycle_calcul_5carte :
         for i in 1..52 LOOP
            for j in 1..52 LOOP
               Set_liste_carte(Liste_alea_1(i), main_tmp,1);
               Set_liste_carte(Liste_alea_2(j), main_tmp,2);
            
               if Unicite_cartes(concatenation_cartes(main_tmp, concatenation_cartes(Get_joueur_main(Self),Table))) THEN
                  nbr_simu := nbr_simu + 1;
                  Set_joueur_main(other_tmp, main_tmp);
                  if Self_gagne(Combinaison_self,self,other_tmp,Table) THEN
                     nbr_gagne := nbr_gagne + 1;
                  end if;
               end if;
               
               exit Cycle_calcul_5carte when (Float(Clock-Temps_init)>Limite_duree);
               
            End LOOP;
         End LOOP Cycle_calcul_5carte;
         
      end if;
      
      return (nbr_gagne*100)/nbr_simu;
   End;
   
   function Get_puissance_main(Table : IN T_liste_cartes ; Self : T_joueur ; Limite_duree : IN Float) return Natural is
      puissance : Natural := 0;
   Begin
      if Get_nbr_liste_carte(Table) < 3 THEN
         puissance := pourcentage_gagne_PostFlop_TimeLimited(Table, Self, Limite_duree);
      else
         puissance := Natural(puispreflop(Self));
      end if;
      return puissance;
   end;
   

   
   Function puispreflop(joueur: IN T_joueur) return Float is 
      pourc : float := 0.0;
      motif1 : natural;
      motif2 : natural;
   begin
      motif1:=T_Motif'Pos(Get_carte_motif(Carte => Get_liste_carte(Get_joueur_main(joueur => joueur), 1 ))); --(parametre dans lequel je prends => variable)
      motif2:=T_Motif'Pos(Get_carte_motif(Carte => Get_liste_carte(Get_joueur_main(joueur => joueur), 2 )));      
      -- si on a une même couleur: partie supérieure du tableau
      if Get_carte_couleur(Get_liste_carte(Get_joueur_main(joueur => joueur),1))=Get_carte_couleur(Get_liste_carte(Get_joueur_main(joueur => joueur),2)) then
         if motif1 > motif2 then
            pourc:=(Data_winPreFlop(12-motif1,12-motif2))*100.0;
         else  pourc:=(Data_winPreFlop(12-motif2,12-motif1))*100.0;
         end if;
         -- sinon partie inferieure   
      else
         if motif1 > motif2 then
            pourc:=(Data_winPreFlop(12-motif2,12-motif1))*100.0;
         else  pourc:=(Data_winPreFlop(12-motif1,12-motif2))*100.0;
         end if;
      end if;
      return pourc;
   end puispreflop;
   
end Evaluation_main;
