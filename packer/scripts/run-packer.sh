#!/bin/sh

# Wrapper script for running Packer in a container

set -eu

SCRIPT_DIR=`dirname ${0}` 

cd $SCRIPT_DIR/..

packer validate $2
packer $1 $2
