#!/bin/sh

sudo yum -y update
echo "Built with Packer: `date`" > ${HOME}/build.txt
