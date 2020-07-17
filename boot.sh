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

echo -e "${CYAN}-------------------------RESTART NODEOS--------------------------${NC}"
${NVE_SCRIPTS}/restart.sh

sleep 1
echo -e "${CYAN}----------------------UNLOCK PROJECT WALLET----------------------${NC}"
WALLET_NAME="$( jq -r '.WALLET_NAME' "$config" )";
WALLET_PASSWORD="$( jq -r '.WALLET_PASSWORD' "$config" )";
cleos wallet unlock -n ${WALLET_NAME} --password ${WALLET_PASSWORD}

# Create system accounts
echo
sleep 1
echo -e "${CYAN}-------------------------SYSTEM ACCOUNTS-------------------------${NC}"
cleos create account eosio eosio.bpay EOS7gFoz5EB6tM2HxdV9oBjHowtFipigMVtrSZxrJV3X6Ph4jdPg3
cleos create account eosio eosio.msig EOS6QRncHGrDCPKRzPYSiWZaAw7QchdKCMLWgyjLd1s2v8tiYmb45
cleos create account eosio eosio.names EOS7ygRX6zD1sx8c55WxiQZLfoitYk2u8aHrzUxu6vfWn9a51iDJt
cleos create account eosio eosio.ram EOS5tY6zv1vXoqF36gUg5CG7GxWbajnwPtimTnq6h5iptPXwVhnLC
cleos create account eosio eosio.ramfee EOS6a7idZWj1h4PezYks61sf1RJjQJzrc8s4aUbe3YJ3xkdiXKBhF
cleos create account eosio eosio.saving EOS8ioLmKrCyy5VyZqMNdimSpPjVF2tKbT5WKhE67vbVPcsRXtj5z
cleos create account eosio eosio.stake EOS5an8bvYFHZBmiCAzAtVSiEiixbJhLY8Uy5Z7cpf3S9UoqA3bJb
cleos create account eosio eosio.token EOS7JPVyejkbQHzE9Z4HwewNzGss11GB21NPkwTX2MQFmruYFqGXm
cleos create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.rex EOS5tjK2jP9jAd4zUe7DG1SCFGQW95W2KbXcYxg3JSu8ERjyZ6VRf

echo
sleep 2
echo -e "${CYAN}-------------------ACTIVATE OLD BOOT SEQUENCE--------------------${NC}"
cleos set contract eosio ${EOSIO_CONTRACTS_ROOT}/eosio.boot/
cleos push transaction '{"delay_sec":0,"max_cpu_usage_ms":0,"actions":[{"account":"eosio","name":"activate","data":{"feature_digest":"299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"},"authorization":[{"actor":"eosio","permission":"active"}]}]}'

sleep 2 # NB needs time to before moving on

# Activate consensus upgrade
echo -e "${CYAN}-----------------------ACTIVATING BIOS, PROTOCOL FEATURES-----------------------${NC}"
cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.bios/
echo -e "      BIOS SET"
cleos push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio # GET_SENDER
cleos push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio # FORWARD_SETCODE
cleos push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio # ONLY_BILL_FIRST_AUTHORIZER
cleos push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio # RESTRICT_ACTION_TO_SELF
cleos push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio # DISALLOW_EMPTY_PRODUCER_SCHEDULE
cleos push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio # FIX_LINKAUTH_RESTRICTION
cleos push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio # REPLACE_DEFERRED
cleos push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio # NO_DUPLICATE_DEFERRED_ID
cleos push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio # ONLY_LINK_TO_EXISTING_PERMISSION
cleos push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio # RAM_RESTRICTIONS

# Bootstrap new system contracts
echo -e "${CYAN}-----------------------SYSTEM CONTRACTS-----------------------${NC}"
echo $EOSIO_CONTRACTS_ROOT/eosio.token/
cleos set contract eosio.token $EOSIO_CONTRACTS_ROOT/eosio.token/
cleos set contract eosio.msig $EOSIO_CONTRACTS_ROOT/eosio.msig/
cleos push action eosio.token create '[ "eosio", "100000000000.0000 TLOS" ]' -p eosio.token
echo -e "      TLOS TOKEN CREATED"
cleos push action eosio.token issue '[ "eosio", "350000000.0000 TLOS", "Genesis tokens" ]' -p eosio
echo -e "      TLOS TOKEN ISSUED"
sleep 1
cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.system/ -x 2000 -p eosio@active
sleep 1
echo -e "      SYSTEM SET"
cleos push action eosio setpriv '["eosio.msig", 1]' -p eosio@active
cleos push action eosio init '[0, "4,TLOS"]' -p eosio@active

#cleos set abi eosio.rex $EOSIO_CONTRACTS_ROOT/eosio.system/.rex/rex.results.abi

# Deploy eosio.wrap
echo -e "${CYAN}-----------------------EOSIO WRAP-----------------------${NC}"
cleos system newaccount eosio eosio.wrap EOS7LpGN1Qz5AbCJmsHzhG7sWEGd9mwhTXWmrYXqxhTknY2fvHQ1A --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 50 --transfer
cleos push action eosio setpriv '["eosio.wrap", 1]' -p eosio@active
cleos set contract eosio.wrap $EOSIO_CONTRACTS_ROOT/eosio.wrap/

echo -e "${GREEN}--> Done${NC}"
