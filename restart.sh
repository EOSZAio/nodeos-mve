#!/bin/bash

echo -e "${CYAN}-------------------------NODEOS FOLDERS--------------------------${NC}"
config="config.json"
NVE_ROOT="$( jq -r '.NVE_ROOT' "$config" )";
NVE_NODEOS="$( jq -r '.NVE_NODEOS' "$config" )";
NVE_SCRIPTS="$( jq -r '.NVE_SCRIPTS' "$config" )";

cd ${NVE_SCRIPTS}

echo -e "${GREEN}=====start.sh=====${NC}"
echo "working folder"
pwd
echo -e "${CYAN}NVE_ROOT = ${NVE_ROOT}${NC}"
echo -e "${CYAN}NVE_NODEOS = ${NVE_NODEOS}${NC}"
echo -e "${CYAN}NVE_SCRIPTS = ${NVE_SCRIPTS}${NC}"

${NVE_SCRIPTS}/stop.sh

rm ${NVE_NODEOS}/nodeos.log
rm ${NVE_NODEOS}/nodeos.tty
rm -r ${NVE_NODEOS}/data
rm -r ${NVE_NODEOS}/protocol_features

${NVE_SCRIPTS}/start.sh

sleep 3

curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq
