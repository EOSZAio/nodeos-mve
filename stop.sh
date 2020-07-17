#!/bin/bash

echo -e "${CYAN}-------------------------NODEOS FOLDERS--------------------------${NC}"
config="config.json"
NVE_ROOT="$( jq -r '.NVE_ROOT' "$config" )";
NVE_NODEOS="$( jq -r '.NVE_NODEOS' "$config" )";
NVE_SCRIPTS="$( jq -r '.NVE_SCRIPTS' "$config" )";

cd ${NVE_SCRIPTS}

echo -e "${GREEN}=====stop.sh=====${NC}"
echo "working folder"
pwd
echo -e "${CYAN}NVE_ROOT = ${NVE_ROOT}${NC}"
echo -e "${CYAN}NVE_NODEOS = ${NVE_NODEOS}${NC}"
echo -e "${CYAN}NVE_SCRIPTS = ${NVE_SCRIPTS}${NC}"

if [ -f ${NVE_NODEOS}"/nodeos.pid" ]; then
	pid=`cat ${NVE_NODEOS}"/nodeos.pid"`
	echo $pid
	kill $pid
	rm -r ${NVE_NODEOS}"/nodeos.pid"

	echo -ne "Stoping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rNodeos Stopped.    \n"
fi
