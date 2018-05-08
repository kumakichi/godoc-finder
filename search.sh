#!/bin/bash

DB_FILE=PKG.db
caseSensitive=0
showTypes="all" #all types
pkgName=""

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

while getopts "st:p:" o; do
    case "${o}" in
        s)
            caseSensitive=1
            ;;
        t)
            if [ "${OPTARG}" = "f" ]
            then
		    showTypes="function"
            elif [ "${OPTARG}" = "m" ]
            then
		    showTypes="method"
            elif [ "${OPTARG}" = "t" ]
            then
		    showTypes="type"
            fi
            ;;
        p)
            pkgName=${OPTARG}
            ;;
        *)
            echo "Invalid option, prog will exit not"
            exit
            ;;
    esac
done
shift $((OPTIND-1))

if [ $# -lt 1 ]
then
    echo "Usage: $0 [-s] [-t f/t/m] [-p pkgName] symbolName"
    echo "-s if specified, symbolName case sensitive"
    echo "-p search only the specified package name"
    echo "-t f/t/m"
    echo "   f -> function"
    echo "   t -> type"
    echo "   m -> method"
	
    exit
fi

symbolName=$1
resultContent=""

if [ $caseSensitive -eq 1 ] # case sensitive
then
	if [ $showTypes != "all" ]
	then
		resultContent=$(grep -E ^[A-Za-z]*$symbolName $DB | awk -v types=$showTypes '{if($2==types)print $1,$3,":: godoc "$3,$1";"}')
	else
		resultContent=$(grep -E ^[A-Za-z]*$symbolName $DB | awk '{print $1,$3,"[",$2,"]:: godoc "$3,$1";"}')
	fi
else
	if [ $showTypes != "all" ]
	then
		resultContent=$(grep -i -E ^[A-Za-z]*$symbolName $DB | awk -v types=$showTypes '{if($2==types)print $1,$3,":: godoc "$3,$1";"}')
	else
		resultContent=$(grep -i -E ^[A-Za-z]*$symbolName $DB | awk '{print $1,$3,"[",$2,"]:: godoc "$3,$1";"}')
	fi
fi

if [ "$pkgName" != "" ]
then
	echo $resultContent | sed -e 's/; /\n/g;s/;/\n/g' | awk -v p=$pkgName '{if($2==p)print $0}' | sed 's/; /\n/g'
	#echo $resultContent | sed 's/; /\n/g' | awk -v p=$pkgName '{if($2~/p/)print $0}' | sed 's/; /\n/g'
else
	echo $resultContent | sed -e 's/; /\n/g;s/;/\n/g'
fi
