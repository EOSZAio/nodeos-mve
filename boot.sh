#!/usr/bin/env bash
# Usage: ./boot.sh

# Assumptions: nodeos already running somewhere,
# wallet created, ENV vars set for wallet name and password
# contracts already compiled (with abi's generated),
# located in their respective directories, placed into user's root home folder

# Create wallet with command:
#   cleos wallet create -n testwallet --to-console
#   [NOTE] record your password somewhere
#   Password : PW5JdKqyPfeHDUurSiXoBtrF1LdCBeNTWFpsshpw7bpkqrniZ3uqE

# Set ENV vars:
#   export WALLET="testwallet"
#   export PASSWORD="{your password here}"
#   export PASSWORD="PW5JdKqyPfeHDUurSiXoBtrF1LdCBeNTWFpsshpw7bpkqrniZ3uqE"

# In a separate terminal window, run nodeos locally with this exact command:
#   nodeos -e -p eosio --max-transaction-time=1000 --http-validate-host=false --delete-all-blocks --contracts-console --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::producer_plugin --plugin eosio::http_plugin

# https://github.com/EOSIO/eos/issues/7180
# curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

# https://local.bloks.io/?nodeUrl=127.0.0.1:8888&coreSymbol=TLOS&systemDomain=eosio

#=================================================================================#
# Config Constants
clear

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}-------------------------NODEOS FOLDERS--------------------------${NC}"
config="config.json"
NVE_ROOT="$( jq -r '.NVE_ROOT' "$config" )";
NVE_NODEOS="$( jq -r '.NVE_NODEOS' "$config" )";
NVE_SCRIPTS="$( jq -r '.NVE_SCRIPTS' "$config" )";
EOSIO_CONTRACTS_ROOT="$( jq -r '.EOSIO_CONTRACTS_ROOT' "$config" )";

cd ${NVE_SCRIPTS}

echo -e "${GREEN}=====start.sh=====${NC}"
echo "current working directory"
pwd
echo -e "${CYAN}NVE_ROOT = ${NVE_ROOT}${NC}"
echo -e "${CYAN}NVE_NODEOS = ${NVE_NODEOS}${NC}"
echo -e "${CYAN}NVE_SCRIPTS = ${NVE_SCRIPTS}${NC}"
echo -e "${CYAN}EOSIO_CONTRACTS_ROOT = ${EOSIO_CONTRACTS_ROOT}${NC}"

#./compile_ref.sh

echo -e "${CYAN}-------------------------RESTART NODEOS--------------------------${NC}"
${NVE_SCRIPTS}/restart.sh

#echo -e "${GREEN}--> Done${NC}"

#tail -n 200 -f ${NVE_NODEOS}/nodeos.log
