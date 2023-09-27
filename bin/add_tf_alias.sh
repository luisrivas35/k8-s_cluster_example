#!/usr/bin/env bash

# Define the alias command
alias_command='alias tf="terraform"'

# Check if the alias already exists in .bash_profile
grep -qxF "$alias_command" ~/.bash_profile

# Check the exit status of the grep command
if [ $? -ne 0 ]; then
  # If the alias doesn't exist, add it to .bash_profile
  echo "$alias_command" >> ~/.bash_profile
  echo "Alias 'tf' for 'terraform' added to ~/.bash_profile."
else
  echo "Alias 'tf' for 'terraform' already exists in ~/.bash_profile."
fi
