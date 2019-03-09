#!/bin/sh
#reminder to use neovim over vim

#check if neovim is even an option:
which nvim > /dev/null 2>&1
NVERR=$?
if [ $NVERR -ne "0" ];
then
    #echo "no neovim"
    vim "$@"
    exit 0
fi

echo "you should use Neovim instead of Vim."
echo "run 'nvim <file>' instead."
echo "opening Vim in..."
sleep 1
printf "3..."
sleep 1
printf "2..."
sleep 1
printf "1...\n"
sleep 1
vim "$@"
