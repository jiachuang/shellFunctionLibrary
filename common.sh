#!/bin/bash
#http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
function command_exists()
{
    command -v "$1" > /dev/null 2>&1
}
