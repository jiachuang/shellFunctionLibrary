#!/bin/bash

# must ensure expect is installed

# Load the common.sh
. common.sh

function remote_command()
{
    local ip=$1
    local user=$2
    local password=$3
    local timeout=$4
    local cmd=$5
    local expect_command="expect"

    # >&2 is 1>&2
    command_exists "${expect}" || { echo >&2 "I require ${expect} but it's not installed.  Aborting."; exit 1; }

    expect -c "
    set timeout $timeout;
    spawn ssh $user@$ip \"$cmd\";
    expect {
        \"*yes/no\" { send \"yes\r\"; exp_continue}
        \"*password:\" { send \"$password\r\"; exp_continue}
        eof
    };"
}

function remote_copy()
{
    local ip=$1
    local user=$2
    local password=$3
    local local_file=$4
    local remote_path=$5
    local directory_option=""

    if [ -d "${local_file}" ]; then
        directory_option="-r"
    fi

    # >&2 is 1>&2
    command_exists "${expect}" || { echo >&2 "I require ${expect} but it's not installed.  Aborting."; exit 1; }

   # disable tiemout to wait scp finished
    expect -c "
    set timeout -1;
    spawn bash -c \"scp $directory_option $local_file $user@$ip:$remote_path\";
    expect {
        \"*yes/no\" { send \"yes\r\"; exp_continue}
        \"*password:\" { send \"$password\r\"; exp_continue}
        eof
    };"
}
