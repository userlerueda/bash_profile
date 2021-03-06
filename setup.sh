#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
# Uncomment the next line if you want to debug
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
#__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

arg1="${1:-}"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGGER="echo $(date +"%Y-%m-%d %H:%M") "
LOGGER_INFO="echo $(date +"%Y-%m-%d %H:%M") | INFO | "

# Installer starts here
# Validate homebrew is installed
if ( brew --version > /dev/null 2>&1 )
then
  ${LOGGER} "Homebrew is already installed"
else
  ${LOGGER} "Homebrew is NOT installed, installing..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
# Validate pip is installed
if ( pip --version > /dev/null 2>&1 )
then
  ${LOGGER} "pip is already installed"
else
  ${LOGGER} "pip is not installed, installing..."
  brew install python
fi

# Install pip requirements
if ( ansible --version > /dev/null 2>&1 )
then
  ${LOGGER} "ansible is already installed, continuing..."
else
  ${LOGGER} "Installing python requirements via pip"
  pip install -r _data/requirements.txt
fi

# Execute intallation
${LOGGER} "Executing ansible playbook"
cd ansible
ansible-playbook site.yml
