import subprocess
import random
import csv

Nombre_test = 50

motif = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
couleur = ["s", "d", "h", "c"]

resultats = []
    
for i in range(Nombre_test):
    Args = ["update_hand;table;{}{},{}{},{}{}".format(random.choice(motif),random.choice(couleur),random.choice(motif),random.choice(couleur),random.choice(motif),random.choice(couleur)),"update_hand;hand;self;{}{},{}{}".format(random.choice(motif),random.choice(couleur),random.choice(motif),random.choice(couleur))]
    
    SubP_S2 = subprocess.Popen(["test_taux_gagne.exe", Args[0], Args[1]], stdout = subprocess.PIPE)
    result = SubP_S2.communicate()
    data_row = []
    
    data_row.append(int(result[0].decode(encoding='UTF-8',errors='strict').split("; ")[0]))
    data_row.append(float(result[0].decode(encoding='UTF-8',errors='strict').split("; ")[1]))
    
    SubP_S1 = subprocess.Popen(["test_evaluation_main.exe", Args[0], Args[1]], stdout = subprocess.PIPE)
    result = SubP_S1.communicate()
    
    data_row.append(int(result[0].decode(encoding='UTF-8',errors='strict').split("; ")[0]))
    data_row.append(float(result[0].decode(encoding='UTF-8',errors='strict').split("; ")[1]))
    
    resultats.append(data_row)
    
with open('Comparaison_new_bis.csv', mode='w') as comparaison_file:
    comparaison_writer = csv.writer(comparaison_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for row in resultats :
            comparaison_writer.writerow(row)