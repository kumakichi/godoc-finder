#!/bin/bash

DB_FILE=PKG.db
caseSensitive=0

realscript=$(readlink ${BASH_SOURCE}) # soft link
if [ "$realscript" = "" ]
then
    realscript=$(ls -l ${BASH_SOURCE} | awk '{print $9}') # called : ./search.sh
fi

prog_path=${realscript%/*}
DB=${prog_path}/${DB_FILE}

if [ ! -f $DB ]
then
    echo "db file '$DB' not found, run 'build.sh' first"
    exit
fi

while getopts "s" o; do
    case "${o}" in
        s)
            caseSensitive=1
            ;;
        *)
            ;;
    esac
done
shift $((OPTIND-1))

if [ $# -lt 1 ]
then
    echo "Usage: $0 [-s] symbolName"
    echo "support type, func and method currently"
    echo "-s if specified, symbolName case sensitive"
	
    exit
fi

symbolName=$1


if [ $caseSensitive -eq 1 ]
then
	grep -E ^[A-Za-z]*$symbolName* $DB | awk '{print $1,$3,"[",$2,"]:: godoc "$3,$1}'
else
	grep -i -E ^[A-Za-z]*$symbolName* $DB | awk '{print $1,$3,"[",$2,"]:: godoc "$3,$1}'
fi
