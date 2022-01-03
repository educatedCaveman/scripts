#!/bin/bash
GIT_DIR="$HOME/ansible"
echo $GIT_DIR
GIT_LINES=( $(git -C $GIT_DIR --no-pager log -m -10 --name-only | grep "^roles" | sort -u) )

echo ${#GIT_LINES[@]}

for i in "${git_lines[@]}"
do
    echo $i
done