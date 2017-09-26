#!/bin/bash

filename="ayya-sunlight-10000px.zip"
length=${#filename}

echo "$length"

trimmed=$(echo $filename | cut -d '.' -f 1)
echo $trimmed
