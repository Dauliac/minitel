#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import random

from minitel.Minitel import Minitel
from minitel.ui.Menu import Menu


from minitel.Sequence import Sequence # Gestion des séquences de caractères

from minitel.constantes import (SS2, SEP, ESC, CSI, PRO1, PRO2, PRO3, MIXTE1,
    MIXTE2, TELINFO, ENQROM, SOH, EOT, TYPE_MINITELS, STATUS_FONCTIONNEMENT,
    LONGUEUR_PRO2, STATUS_TERMINAL, PROG, START, STOP, LONGUEUR_PRO3,
    RCPT_CLAVIER, ETEN, C0, MINUSCULES, RS, US, VT, LF, BS, TAB, CON, COF,
    AIGUILLAGE_ON, AIGUILLAGE_OFF, RCPT_ECRAN, EMET_MODEM, FF, CAN, BEL, CR,
    SO, SI, B300, B1200, B4800, B9600, REP, COULEURS_MINITEL,
    CAPACITES_BASIQUES, CONSTRUCTEURS)

minitel = Minitel()

minitel.deviner_vitesse()
minitel.identifier()
minitel.definir_vitesse(minitel.capacite['vitesse'])

def test_recevoir_sequence(bloque = True, attente = None):
    """ Test de la fonction recevoir_sequence

    La fonction est une boucle infinie qui attend de recevoir
    une séquence du minitel et imprime le résultat dans le shell.

    Pour arrêter la fonction : Ctrl+C

    Notes:
        recevoir_sequence renvoit une erreur en mode bloquant
            avec temps d'attente si le minitel n'envoit rien.
            Il faut donc être sûr qu'un message soit attendu au moment de son appel.
    """
    count = 0
    while True:
        # recevoir_sequence emet une erreur si bloque = False et
        # que rien n'est reçu
        count = count + 1
        seq = minitel.recevoir_sequence(bloque, attente)
        txt = ''
        for val in seq.valeurs:
            txt = txt + chr(val)
        print("#", count, " : ", txt)

def test_recevoir(bloque = True, attente = None):
    """ Test de la fonction recevoir

    La fonction est une boucle infinie qui attend de recevoir
    un caractère du minitel et imprime le résultat dans le shell.

    Pour arrêter la fonction : Ctrl+C

    Notes:
        recevoir() renvoit un '' en mode bloquant si le minitel
            n'envoit rien.
    """
    count = 0
    while True:
        count = count + 1
        val = minitel.recevoir(bloque, attente)
        if val:
            print("#", count, " : ", val)

def test_envoyer(data = None):
    """ Test de la fonction envoyer

    La fonction a 2 modes de fonctionnement en fonction de l'argument
        - Si un argument est donné: elle envoie simplement l'argument
            au minitel et se termine
        - Si il n'y a pas d'argument, elle boucle infiniment en demandant
            une entrée à envoyer au minitel dans le shell

            Pour arrêter la fonction : Ctrl+C

    Notes:
        On peut afficher "AB" des manières suivantes
            envoyer(data = "AB")
            envoyer(data = [65,66])
            envoyer(data = b'AB'.decode())
    """
    if not data:
        #loop input prompt
        while True:
            text = input(" > ")
            minitel.envoyer(text)
    else:
        #send data arg
        minitel.envoyer(data)

def affiche_videotex(fichier):
    """ Fonction permettant d'afficher un fichier videotex (.vdt .vtx)

    Param: chemin du fichier à afficher
        e.g. affiche_videotex("/foo/bar.vdt")
    """
    with open(fichier, 'rb') as f:
        minitel.envoyer_brut(f.read())

minitel.efface()

while True:
    affiche_videotex('xana.vdt')
    delay = random.uniform(2, 30)
    time.sleep(delay)
