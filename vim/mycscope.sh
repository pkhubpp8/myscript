#!/bin/bash
# README: 
# 1. pls modify /etc/crontab if rename this file.
# 2. pls make sure the path parameter is correct.

export NVM_DIR="/home/nzhou/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

SRCPATH=./
ERRLOG=/home/nzhou/cronderr.log
CURPWD=$PWD
NPM=/home/nzhou/.nvm/versions/node/v4.8.7/bin/npm
LOGFILESIZE=`ls $ERRLOG -l | awk -F\  '{print $5}'`
LOGFILESIZE_KB=`expr $LOGFILESIZE / 1024`
LOGFILESIZE_M=`expr $LOGFILESIZE_KB / 1024`
function output(){
    echo $1:$2 >> $ERRLOG
}

if [ $LOGFILESIZE_M -ge 10 ];then
    echo > $ERRLOG;
    output "info" "log file is too large, clean it"
fi

if [ $1 ]; then
    output "info" $1
    SRCPATH=$1
elif [ -d ./src ] && [ -d ./node_modules ]; then
    output "info" "./"
fi

output "info"  "=============start to update cscope===================" 
date  >> $ERRLOG
output "info"  "$SRCPATH" 

if [ ! -d $SRCPATH -o ! -e $SRCPATH/node_modules ]; then 
    output "error"  "$SRCPATH is not a directory or $SRCPATH/node_modules not exist" 
    output "info"  "=============end to update cscope files===============" 
    exit 100
fi

cd $SRCPATH
CHANGELIST=`git st -s | grep -vE "^\?\?" | grep -v "gitignore"`
if [ -z "$CHANGELIST" ]; then
    output "info" "nothing changed"
    git pull;
else
    output "info"  "something changed" 
fi

# rm ./node_modules -rf;
$NPM install
if [ $? -ne 0 ]; then
    output "error"  "npm install failed" 
    $NPM install >> $ERRLOG
fi

if [ -f cscope.files ]; then 
    rm cscope.files cscope.in.out cscope.po.out cscope.out
fi
find $SRCPATH/src -name "*.js" >> cscope.files
find $SRCPATH/node_modules -name "*.js" >> cscope.files
find $SRCPATH/test -name "*.js" >> cscope.files
cscope -Rbqk

output "info"  "=============end to update cscope files===============" 
output "info" ""

cd $CURPWD

