#!/bin/sh
#reminder to use neovim over vim

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
vim $1
