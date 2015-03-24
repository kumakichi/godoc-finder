#!/bin/bash

DB=PKG.db

if [ ! -f $DB ]
then
    echo "db file '$DB' not found, run 'build.sh' first"
    exit
fi

if [ $# -lt 1 ]
then
    echo "Usage: $0 name(ignore case), only support type and func currently"
    exit
fi

name=$1

if [ $# -eq 1 ]
then
    echo -e "func and types of '$name' :\n"
    grep -i -E [A-Za-z]*$name.* $DB | awk '{print $1,$3}'
fi
