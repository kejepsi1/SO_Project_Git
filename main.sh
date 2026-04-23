#!/bin/bash
obsluga_gui() {
    if [ ! -f ".token.enc" ]; then
        zenity --info --text "Pierwsze uruchomienie. Musisz bezpiecznie skonfigurować token dostępu do GitHuba." --title "Konfiguracja Tokenu"
        
        token=$(zenity --password --title "Wklej swój GitHub Token")
        haslo_szyfrujace=$(zenity --password --title "Wymyśl hasło główne do zabezpieczenia tokenu")

        echo "$token" | openssl enc -aes-256-cbc -pbkdf2 -a -salt -pass pass:"$haslo_szyfrujace" > .token.enc
        
        odkodowany_token="$token"
        zenity --info --text "Token został zaszyfrowany i zapisany lokalnie!" --title "Sukces"
    else
        haslo_odblokowania=$(zenity --password --title "Podaj hasło główne, aby odblokować Git Token")
        
        if [ $? -ne 0 ]; then
            zenity --error --text "Anulowano wpisywanie hasła. Przerywam działanie." --title "Anulowano"
            exit 1
        fi
        
        odkodowany_token=$(cat .token.enc | openssl enc -aes-256-cbc -pbkdf2 -a -d -salt -pass pass:"$haslo_odblokowania" 2>/dev/null)
        
        if [ $? -ne 0 ]; then
            zenity --error --text "Błędne hasło! Nie można odblokować tokenu." --title "Błąd autoryzacji"
            exit 1
        fi
    fi

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

    HELPER="!f() { echo \"username=git\"; echo \"password=$odkodowany_token\"; }; f"

    tail -n +3 konfiguracja.txt | while read -r link; do
        katalog=$(basename "$link" .git)
        if [ -d "$katalog" ]; then
            zenity --info --text "Repozytorium $link zostało już pobrane, wykonuję pull." --title "Pull"
            git -c credential.helper="$HELPER" -C "$katalog" pull
        else
            if git -c credential.helper="$HELPER" clone "$link"; then
                zenity --info --text "Pobrano repozytorium $link" --title "Success"
            else
                zenity --error --text "Nie znaleziono repozytorium pod tym linkiem." --title "Not Found"
            fi
        fi
    done

    zenity --info --text "Wszystkie repozytoria zostały pobrane pomyślnie" --title "Success"
}