#!/bin/bash

DB=PKG.db

function funs()
{
    pkg=$1
    godoc $pkg | awk -v p=${pkg} -F'[ (]' '/^func /{if(length($2)>1)print $2,"=func=",p}' >>$DB
}

function types()
{
    pkg=$1
    godoc $pkg | awk -v p=${pkg} '/^type /{print $2,"=type=",p}' >>$DB
}

if [ "$GOROOT" = "" ]
then
    echo "'GOROOT' not setted,please set it first"
    exit
fi

>$DB
for each in $(find $GOROOT/src -mindepth 1 -maxdepth 10 -type d -exec echo '{}' \; | sed "s|$GOROOT/src/||g")
do
    echo $each
    funs $each
    types $each
done
