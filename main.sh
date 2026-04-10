#!/bin/bash

echo "$(zenity --entry --text "Podaj imie i nazwisko" --title "Dodawanie nazwy")" > konfiguracja.txt
echo "$(zenity --entry --text "Podaj e-mail" --title "Dodawanie maila")" >> konfiguracja.txt

git config --global user.name "Mikołaj Tchorek"
git config --global user.email "miko.tchorek@gmail.com"

while zenity --question --text "Czy chcesz dodać kolejne repozytorium?" --title "Dodawanie repozytorium"; do
    echo "$(zenity --entry --text "Podaj link do repozytorium" --title "Link do repo")" >> konfiguracja.txt
done