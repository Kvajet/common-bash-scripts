#!/bin/bash

#===============================================================================
#
#          FILE:  timer.sh
#
#         USAGE:  ./timer.sh
#
#   DESCRIPTION:  basic timer app accepting exactly one parameter which is positive integer representing seconds
#
#        AUTHOR:  Jan Tichý, kvajet@gmail.com
#       VERSION:  1.0
#       CREATED:  16.03.2021
#===============================================================================

trap 'onexit 130' SIGINT

function onstart()
{
    rem=$1
    tput civis
    width=$( tput cols )
}

function onexit()
{
    tput cnorm
    exit $1
}

function validateInput()
{
    if [ $# -ne 1 ]
    then
        echo "You entered invalid number of arguments."
        exit 1
    fi

    numRegex="^[0-9]+$"
    if ! [[ $1 =~ $numRegex ]] || [ $1 -eq 0 ]
    then
        echo "Number is not valid positive integer."
        exit 2
    fi
}

validateInput $@
onstart $1

while (( $rem ))
do
    if [ $width -ne $( tput cols ) ]
    then
        clear
        width=$( tput cols )
    fi

    calc=$(( $( tput cols ) - $( echo -n $rem | wc -c ) ))
    margin=$(( ( $calc / 2 ) + ( $calc % 2 ) ))


    if [ $rem -ne $1 ]
    then
        tput cuu 1
        tput el
    fi

    printf " %.0s" $( seq 1 $margin )
    printf "%d\n" "$rem"

    sleep 1
    rem=$(( $rem - 1 ))
done

trap 'onexit 0' EXIT
