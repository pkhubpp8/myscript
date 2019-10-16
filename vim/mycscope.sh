#!/bin/bash

SRCPATH=./
CSFILE=./
ERRLOG=~/cronderr.log
CURPWD=$PWD

if [ ! -f $ERRLOG ]; then touch $ERRLOG; fi
LOGFILESIZE=`ls $ERRLOG -l | awk -F\  '{print $5}'`
LOGFILESIZE_KB=`expr $LOGFILESIZE / 1024`
LOGFILESIZE_M=`expr $LOGFILESIZE_KB / 1024`
TYPE="cpp"
function output(){
    echo $1:$2 >> $ERRLOG
}

if [ $LOGFILESIZE_M -ge 10 ];then
    echo > $ERRLOG;
    output "info" "log file is too large, clean it"
fi

if [ $1 ]; then
    SRCPATH=$1
    output "info" $1
else
    output "info" "SRCPATH ./"
fi

if [ $2 ]; then
    CSFILE=$2;
else
    output "info" "CSFILE ./"
fi

if [ $3 ]; then
    TYPE=$3;
fi

output "info"  "=============start to update cscope==================="
date  >> $ERRLOG

if [ -f $CSFILE/cscope.files ]; then
    cd $CSFILE
    rm cscope.files cscope.in.out cscope.po.out cscope.out
    cd -
    output "info"  "$CSFILE cscope files removed"
fi

if [ $TYPE = "js" ]; then

    if [ ! -d $SRCPATH -o ! -e $SRCPATH/package.json ]; then
        output "error"  "$SRCPATH is not a directory or $SRCPATH/package.json not exist"
        output "info"  "=============end to update $CSFILE/cscope.files==============="
        exit 100
    fi

    cd $SRCPATH
    # rm ./node_modules -rf;
    find $SRCPATH/src -name "*.js" >> $CSFILE/cscope.files
    find $SRCPATH/node_modules -name "*.js" >> $CSFILE/cscope.files
    find $SRCPATH/test -name "*.js" >> $CSFILE/cscope.files
elif [ $TYPE = "c" ]; then
    find $SRCPATH -name "*.c" >> $CSFILE/cscope.files
    find $SRCPATH -name "*.h" >> $CSFILE/cscope.files
elif [ $TYPE = "cpp" ]; then
    find $SRCPATH -name "*.cpp" >> $CSFILE/cscope.files
    find $SRCPATH -name "*.hpp" >> $CSFILE/cscope.files
    find $SRCPATH -name "*.c" >> $CSFILE/cscope.files
    find $SRCPATH -name "*.h" >> $CSFILE/cscope.files
fi
cscope -Rbqk

output "info"  "=============end to update $CSFILE/cscope.files==============="
output "info" ""

cd $CURPWD

