#!/bin/bash

echo Input key name:
read keyname

echo "Your key name $keyname"

ssh-keygen -f ~/.ssh/$keyname -C \"$keyname\"
cat ~/.ssh/"$keyname".pub
ssh-add ~/.ssh/$keyname
pbcopy < ~/.ssh/"$keyname".pub


echo "ssh key on clipboard"