#!/bin/bash

echo -e "${CYAN}-------------------------NODEOS FOLDERS--------------------------${NC}"
config="config.json"
NVE_ROOT="$( jq -r '.NVE_ROOT' "$config" )";
NVE_NODEOS="$( jq -r '.NVE_NODEOS' "$config" )";
NVE_SCRIPTS="$( jq -r '.NVE_SCRIPTS' "$config" )";

cd ${NVE_SCRIPTS}

tail -n 100 -f ${NVE_NODEOS}/nodeos.log
