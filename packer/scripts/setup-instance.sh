#!/bin/sh

# Setup script to configure a machine image

set -eu

sudo yum -y update
echo "Built with Packer: `date`" > ${HOME}/build-info.txt
