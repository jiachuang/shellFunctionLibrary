#!/bin/bash
function infoMsg()
{
    echo -e "\033[33m[INFO]$1\033[0m" # yellow
}

function warningMsg()
{
    echo -e "\033[35m[WARNING]$1\033[0m" # purple
}

function errorMsg()
{
    echo -e "\033[31m[ERROR]$1\033[0m" # red
}

function promptMsg()
{
    echo -e "\033[32m$1\033[0m" # green 
}


#http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
function commandExists()
{
    command -v "$1" > /dev/null 2>&1
}

#http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
function containsElement()
{
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

#https://zindilis.com/blog/2013/05/10/bash-check-that-string-is-ip.html
function isIP()
{
    local ip=$1
    if [ `echo $ip | grep -o '\.' | wc -l` -ne 3 ]; then
        errorMsg "Parameter '$ip' does not look like an IP Address (does not contain 3 dots).";
        return 1;
    elif [ `echo $ip | tr '.' ' ' | wc -w` -ne 4 ]; then
        errorMsg "Parameter '$ip' does not look like an IP Address (does not contain 4 octets).";
        return 1;
    else
        for OCTET in `echo $ip | tr '.' ' '`; do
            if ! [[ "$OCTET" =~ ^[0-9]+$ ]]; then
                errorMsg "Parameter '$ip' does not look like in IP Address (octet '$OCTET' is not numeric).";
                return 1;
            elif [[ "$OCTET" -lt 0 || "$OCTET" -gt 255 ]]; then
                errorMsg "Parameter '$ip' does not look like in IP Address (octet '$OCTET' in not in range 0-255).";
                return 1;
            fi
        done
    fi
    return 0;
}

#https://stackoverflow.com/questions/25004021/telnet-to-determine-open-ports-shell-script
function portIsOpen()
{
    local ip=$1
    local port=$2
    local result=$(echo exit | telnet $ip $port 2>/dev/null | grep "Connected")
    if [[ "$result" == "" ]]; then
        return 1    # not open
    else
        return 0    # open
    fi
}

#https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash?page=1&tab=votes#tab-top
#number >= 0
function isNaturalNumber()
{
    local number=$1
    re='^[0-9]+$'
    if ! [[ $number =~ $re ]]; then
        return 1    # not a number
    else
        return 0    # is a number
    fi
}
