#!/bin/bash



name=$(zenity --entry --text "Podaj imie i nazwisko" --title "Dodawanie nazwy") >> konfiguracja.txt
email=$(zenity --entry --text "Podaj e-mail" --title "Dodawanie maila") > konfiguracja.txt

git config --global user.name "$name"
git config --global user.email "$email"

while zenity --question --text "Czy chcesz dodać kolejne repozytorium?" --title "Dodawanie repozytorium"; do
    nowe_repo=$(zenity --entry --text "Podaj link do repozytorium" --title "Link do repo")
done