#!/bin/sh

SCRIPT_DIR=`dirname ${0}` 

cd $SCRIPT_DIR/..
packer $1 $2
