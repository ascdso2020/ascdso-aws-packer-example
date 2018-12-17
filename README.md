# Example Project: Packer with AWS

## Prerequisites

* Docker
* AWS credentials file in the ~/.aws/ directory

## Usage

Run the _./do.sh_ script to create the Docker image:

    ./do.sh setup

Next, use the _info_ subcommand to check that the variables are set correctly:

    ./do.sh info

Run the _build_ subcommand to build an AMI, using the Packer template file:

    ./do.sh build
