#!/bin/bash

echo -e "${CYAN}-------------------------NODEOS FOLDERS--------------------------${NC}"
config="config.json"
NVE_ROOT="$( jq -r '.NVE_ROOT' "$config" )";
NVE_NODEOS="$( jq -r '.NVE_NODEOS' "$config" )";
NVE_SCRIPTS="$( jq -r '.NVE_SCRIPTS' "$config" )";

DATADIR=${NVE_NODEOS}/data

cd ${NVE_SCRIPTS}

echo -e "${GREEN}=====start.sh=====${NC}"
echo "working folder"
pwd
echo -e "${CYAN}NVE_ROOT = ${NVE_ROOT}${NC}"
echo -e "${CYAN}NVE_NODEOS = ${NVE_NODEOS}${NC}"
echo -e "${CYAN}NVE_SCRIPTS = ${NVE_SCRIPTS}${NC}"
echo -e "${CYAN}DATADIR = ${DATADIR}${NC}"

nodeos -e -p eosio \
--max-transaction-time=1000 \
--data-dir $DATADIR \
--config-dir ${NVE_NODEOS} \
--contracts-console \
--protocol-features-dir ${NVE_NODEOS}/protocol_features \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::history_plugin \
--plugin eosio::history_api_plugin \
--access-control-allow-origin='*' \
--http-validate-host=false \
--verbose-http-errors >> ${NVE_NODEOS}/nodeos.tty 2>${NVE_NODEOS}/nodeos.log & echo $! > ${NVE_NODEOS}/nodeos.pid
