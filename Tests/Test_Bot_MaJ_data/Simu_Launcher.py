import subprocess

# Creation d'un processus test_maj avec ouverture d'un PIPE en entree/sortie avec le script Python
process = subprocess.Popen('test_maj_bot.exe', shell=True,
                           stdout=subprocess.PIPE, 
                           stderr=subprocess.STDOUT,
                           stdin = subprocess.PIPE)

# Commandes qui vont etre envoyees :
liste_commandes = []
liste_commandes.append("update_game big_blind 42000")
liste_commandes.append("update_game stack self 2000")
liste_commandes.append("update_game big_blind 60")
liste_commandes.append("update_game hand 1")
liste_commandes.append("update_game stack other 20")
liste_commandes.append("update_game stack self 2000")
liste_commandes.append("update_hand min_bet 60")
liste_commandes.append("update_hand hand other 2d,7c")
liste_commandes.append("update_hand hand self Td,Kc")
liste_commandes.append("update_hand pot 90")
liste_commandes.append("update_hand amount_to_call 30")
liste_commandes.append("update_hand table Ks,Kd,Ts")



process.stdin.write(str.encode("{}".format(len(liste_commandes))))
for commande in liste_commandes :
    process.stdin.write(str.encode(commande+"\n")) #Ecriture des commandes sur l'entree standard de test_maj

result = process.communicate()[0] # On lit que STDOUT, STDERR est redirige vers STDOUT
print(result.decode())

process.stdin.close() # Fermeture du process (meme comportement que la methode communicate)
process.wait()