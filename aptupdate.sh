#!/bin/bash
if [ -z "$1" ]
then
    echo Usage:  sudo $0 http://mirrors.ubuntu.com/mirrors.txt
    echo OR consider one of...
    for mirror in `wget http://mirrors.ubuntu.com/mirrors.txt -O - 2> /dev/null`
    do 
        (
            host=`echo $mirror |sed s,.*//,,|sed s,/.*,,`
            echo -e `ping $host -c1 | grep time=|sed s,.*time=,,`:'  \t\t'$mirror
        ) &
        done
    wait
    exit 1
fi

OLD_SOURCE=`cat /etc/apt/sources.list | grep ^deb\ | head -n1 | cut -d\  -f2`

[ -e  /etc/apt/sources.list.orig ] || cp /etc/apt/sources.list /etc/apt/sources.list.orig

cp /etc/apt/sources.list /etc/apt/sources.list.tmp
sed "s,$OLD_SOURCE,$1," < /etc/apt/sources.list.tmp > /etc/apt/sources.list
