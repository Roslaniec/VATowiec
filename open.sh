#!/bin/bash

# Sprawdzamy, czy podano przynajmniej jeden argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [opcje] file"
    echo " -r : readonly"
    exit 1
fi

# Ostatni argument to plik
FILE="${!#}"

# Inne argumenty to opcje
# PARAMS=("${@:1:$#-1}")

# parametry
PARAMS=()

for (( i=1; i<$#; i++ )); do
    arg="${!i}"
    
    case "$arg" in
        -r)
            PARAMS+=("--view")
            ;;
        *)
            PARAMS+=("$arg") # przekaz bez zmian
            ;;
    esac
done

# Rozszerzenie pliku
EXT="${FILE##*.}"

case "$EXT" in
    dbf)
        PARAMS+=('--infilter=dBASE:25')
        ;;
    csv)
        PARAMS+=('--infilter=CSV:44,34,25,1,1/2/2/2/3/2/4/2/5/2/6/2/7/2/8/2/9/2/10/2/11/2/12/2/13/2/14/2/15/2/16/2/17/2/18/2')
        ;;
    *)
        echo "Unknown extension: $EXT"
        exit 1
        ;;
esac

exec libreoffice "${PARAMS[@]}" "$FILE" &
