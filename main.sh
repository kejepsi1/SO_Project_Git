#!/bin/bash

name=$(zenity --entry --text "Podaj imie i nazwisko" --title "Dodawanie nazwy")
email=$(zenity --entry --text "Podaj e-mail" --title "Dodawanie maila")

echo "$name" > konfiguracja.txt
echo "$email" >> konfiguracja.txt

git config --global user.name "$name"
git config --global user.email "$email"

while zenity --question --text "Czy chcesz dodać kolejne repozytorium?" --title "Dodawanie repozytorium"; do
    echo "$(zenity --entry --text "Podaj link do repozytorium" --title "Link do repo")" >> konfiguracja.txt
done

zenity --info --text "Posiadam wszystkie potrzebne informacje. Zaczynam pobierać repozytoria." --title "Info"

tail -n +3 konfiguracja.txt | while read -r link; do
    katalog=$(basename "$link" .git)
    if [ -d "$katalog" ]; then
        zenity --info --text "Repozytorium $link zostało już pobrane, wykonuję pull." --title "Pull"
        git -C "$katalog" pull
    else
        if git clone "$link"; then
            zenity --info --text "Pobrano repozytorium $link" --title "Success"
        else
            zenity --error --text "Nie znaleziono repozytorium pod tym linkiem." --title "Not Found"
        fi
    fi
done

zenity --info --text "Wszystkie repozytoria zostały pobrane pomyślnie" --title "Success"