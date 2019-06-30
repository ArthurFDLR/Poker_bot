import subprocess
import random
import csv
from tqdm import tqdm

Nombre_test = 10

motif = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
couleur = ["s", "d", "h", "c"]
liste_cartes = []


resultats = []

for i in tqdm(range(Nombre_test)):

    # Creer une liste aleatoire de cartes afin de les utiliser en commandes
    liste_cartes = []
    while len(liste_cartes)<7:
        carte = "{}{}".format(random.choice(motif), random.choice(couleur))
        if not carte in liste_cartes:
            liste_cartes.append(carte)

    # Envoie des arguments (messages)
    Args = [
        "update_hand;table;{},{},{}".format(*liste_cartes[0:5]),
        "update_hand;hand;self;{},{}".format(*liste_cartes[5:7])]
    SubP_S2 = subprocess.Popen(["test_comparaison_algo.exe", Args[0], Args[1]], stdout=subprocess.PIPE)
    result = SubP_S2.communicate()

    # Reception des resultats
    data_row = []
    data_row.append(int(result[0].decode(encoding='UTF-8', errors='strict').split("; ")[0]))
    data_row.append(float(result[0].decode(encoding='UTF-8', errors='strict').split("; ")[1]))
    data_row.append("Table : {},{},{}".format(*liste_cartes[0:5]))
    data_row.append("Main self : {},{}".format(*liste_cartes[5:7]))

    resultats.append(data_row)

print(resultats)

# Ecriture d'un fichier pour exploiter les resultats
with open('Comparaison_algo.csv', mode='w') as comparaison_file:
    comparaison_writer = csv.writer(comparaison_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for row in resultats:
        comparaison_writer.writerow(row)