#!/bin/bash
for p in "${1:-focal}"{,-{security,updates}}/{main,restricted,universe,multiverse};do >&2 echo "${p}"
wget -q -c -r -np -R "index.html*" "http://archive.ubuntu.com/ubuntu/dists/${p}/cnf/Commands-amd64.xz"
# wget -q -c -r -np -R "index.html*" "http://archive.ubuntu.com/ubuntu/dists/${p}/cnf/Commands-i386.xz"
done
