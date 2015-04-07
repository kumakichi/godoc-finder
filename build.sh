#!/bin/bash

DB=PKG.db
TMPDB=tmp.PKG.db

function funs()
{
    pkg=$1
    godoc $pkg | awk -v p=${pkg} -F'[ (]' '/^func /{if(length($2)>1)print $2,"=func=",p}' >>$TMPDB
}

function methods()
{
    pkg=$1
    godoc $pkg | awk -F ')' '/^func \(/{if(NF==3)print $2}' | awk -v p=${pkg} -F'[ (]' '{print $2,"=func=",p}' >>$TMPDB
}

function types()
{
    pkg=$1
    godoc $pkg | awk -v p=${pkg} '/^type /{print $2,"=type=",p}' >>$TMPDB
}

if [ "$GOROOT" = "" ]
then
    echo "'GOROOT' not setted,please set it first"
    exit
fi

>$TMPDB
for each in $(find $GOROOT/src -mindepth 1 -maxdepth 10 -type d -exec echo '{}' \; | sed "s|$GOROOT/src/||g")
do
    echo $each
    funs $each
    types $each
    methods $each
done

awk '!a[$0]++' $TMPDB > $DB
rm $TMPDB
