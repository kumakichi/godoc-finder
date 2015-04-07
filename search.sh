#!/bin/bash

DB_FILE=PKG.db

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

if [ $# -lt 1 ]
then
    echo "Usage: $0 name(ignore case), support type, func and method currently"
    exit
fi

name=$1

if [ $# -eq 1 ]
then
    echo -e "funcs/types/methods of '$name' :\n"
    grep -i -E ^[A-Za-z]*$name.* $DB | awk '{print $1,$3}'
fi
