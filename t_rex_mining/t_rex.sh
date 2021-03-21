#!/usr/bin/bash
SECRETS="/home/drake/.zsh_secrets"
TREX_PATH="/home/drake/t_rex"
TREX_URL='ssl://us1.ethermine.org:5555'
NAME="Moria"

. "${SECRETS}"
WALLET_ID="${ETHEREUM_WALLET_ID}"

"${TREX_PATH}/t-rex" -a ethash -o "${TREX_URL}" -u "${WALLET_ID}" -p x -w "${NAME}"
