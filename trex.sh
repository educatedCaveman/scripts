#!/usr/bin/bash
SECRETS="/home/drake/.zsh_secrets"
TREX_PATH="/home/drake/t_rex"
TREX_URL='ssl://us1.ethermine.org:5555'
NAME="Moria"

source "${SECRETS}"
WALLET_ID="${ETHEREUM_WALLET_ID}"

# ./t-rex -a ethash -o ssl://us1.ethermine.org:5555 -u 0xEeFCdd7FbCEE200627FB20a8A68B32bADA517003 -p x -w Moria
sh "${TREX_PATH}/t-rex" -a ethash -o "${TREX_URL}" -u "${WALLET_ID}" -p x -w "${NAME}"
