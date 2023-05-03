#! /bin/bash
REPO=$(echo $1 | cut -d'/' -f2 | cut -d'.' -f1)
echo $REPO
mkdir $REPO
git clone --bare $1 $REPO
