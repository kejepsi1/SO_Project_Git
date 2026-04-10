#!/bin/bash

source $(dirname $0)/main.sh

WERSJA="1.0.0"

while getopts "hv" WYBOR; do
    case $WYBOR in
        h)
            echo "=========================================="
            echo "       MENEDŻER REPOZYTORIÓW GIT"
            echo "=========================================="
            echo "Użycie: ./menedzer.sh [OPCJE]"
            echo ""
            echo "Opcje:"
            echo "  -h    Wyświetla ten komunikat pomocy (Help)"
            echo "  -v    Wyświetla wersję programu (Version)"
            echo ""
            echo "Uruchomienie skryptu bez opcji włącza interfejs graficzny."
            exit 0
            ;;
        v)
            echo "Menedżer Git - Wersja $WERSJA"
            exit 0
            ;;
        \?)
            echo "Błąd. Nieznana opcja."
            echo "Aby uzyskać pomoc wpisz "./menedzer.sh"."
            exit 1
            ;;
    esac
done

obsluga_gui