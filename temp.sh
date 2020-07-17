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

# Paths
EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
PROJECT_HOME=~/Telos-swaps/swaps
MY_CONTRACTS_BUILD=$PROJECT_HOME/contracts
MY_SCRIPTS=$PROJECT_HOME/scripts

echo -e "${GREEN}===== Folders${NC}"
echo -e "${CYAN}EOSIO_CONTRACTS_ROOT = ${EOSIO_CONTRACTS_ROOT}${NC}"
echo -e "${CYAN}PROJECT_HOME = ${PROJECT_HOME}${NC}"
echo -e "${CYAN}MY_CONTRACTS_BUILD = ${MY_CONTRACTS_BUILD}${NC}"
echo -e "${CYAN}MY_SCRIPTS = ${MY_SCRIPTS}${NC}"

TLOSD_ACCOUNT=tlosd
TLOSD_CONTRACT=tlosd

pUSD_ACCOUNT=usd.token
pUSD_CONTRACT=eosio.token
pUSD_ISSUER=pusd.issuer

TLOSD_TOKEN_CONTRACT=$pUSD_ACCOUNT
TLOSD_ISSUER=$TLOSD_ACCOUNT

USER1_ACCOUNT="user1"
USER2_ACCOUNT="user2"

# Stop nodeos
echo
echo -e "${GREEN}===== Stopping nodeos...${NC}"
cd $MY_SCRIPTS
./stop.sh

echo
sleep 3

# Build contracts
echo -e "${GREEN}===== Build contracts...${NC}"
cd $PROJECT_HOME
${MY_SCRIPTS}/compile.sh

echo
sleep 3

# Start nodeos
echo -e "${GREEN}===== Start nodeos...${NC}"
cd $MY_SCRIPTS
./restart.sh

sleep 5

curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

echo
sleep 3

# Begin test
echo -e "${GREEN}===== Starting test...${NC}"

NODEOS_HOST="127.0.0.1"
NODEOS_PROTOCOL="http"
NODEOS_PORT="8888"
NODEOS_LOCATION="${NODEOS_PROTOCOL}://${NODEOS_HOST}:${NODEOS_PORT}"

# Use permanent wallet file
cleos wallet unlock -n development --password PW5KZK6RA5rsT4t1owECPem1hRBUy744zjAvQF3h2SRKiSfJhvCtG

TLOSD_PUB="EOS77s45YiM8xhq7MWxuTdERBDn3ntHG8DTtcdwNVR2Srhxg5SZk7"
TLOSD_PRV="5HrFtXh3ycvp2rSrpJb6bHJimB14adD6WXuQW4LnXA5posqpfAG"

pUSD_PUB="EOS58GvS5PLsW1hDevmdBjaNh346Py21eiaQY987ae1w7VykYPRya"
pUSD_PRV="5JEAUCikvh5vUMxocQKfYgmmPfkFNPdnMimBY94gpG58U2nzoCZ"

pUSD_ISSUER_PUB="EOS7KRhAu8NNkLnoTJEhvGsxLigmNshpAwzi1Kdb8566ou7k3Bfuf"
pUSD_ISSUER_PRV="5KRpjArBkeVAmDvBWFfWFcdRKducqNBX7Ct6f2vzxjdSqBrJe8r"

#ISSUER_PUB="EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3"
#ISSUER_PRV="5KgKxmnm8oh5WbHC4jmLARNFdkkgVdZ389rdxwGEiBdAJHkubBH"

USER_PUB="EOS8UAsFY4RacdaeuadicrkP66JQxPsbNyucmbT8Z4GjwFoytsK9u"
USER_PRV="5JKAjH9WH4XnZCEe8v5Wir7awV4YBTVa8KUSqWJbQR6QGtj4yce"

#VIRTUAL_PUB="EOS833HgCT3egUJRDnW5k3BQGqXAEDmoYo6q1s7wWnovn6B9Mb1pd"
#VIRTUAL_PRV="5JFLPVygcZZdEno2WWWkf3fPriuxnvjtVpkThifYM5HwcKg6ndu"

# USER_VIRTUAL_ACCOUNT1=abcdefgh.zar
#USER_VIRTUAL1_PRV="5JNYwcu5RFKH1zZdzorxnYJFW6A56fR2foFBF4QWYct619ruYJm"
#USER_VIRTUAL1_PUB="EOS6D9dYCoXnc7JSVvbyRLr1ERCAoEgKP7xrqTp4mnrjSCvPTmeJK"

# USER_VIRTUAL_ACCOUNT2=qwertyui.zar
#USER_VIRTUAL2_PRV="5KSz2f4rTXfMu1srQMxXYGjAxdDEUcYsRaHgkSx6t2JUTqzXt9C"
#USER_VIRTUAL2_PUB="EOS5Jfa7rP6Nium4gf5dHLFYaZiM2ZkwQnrHmdKkaphpBoaPnrp6M"

# USER_VIRTUAL_ACCOUNT3=zxcvbnm1.zar
#USER_VIRTUAL3_PRV="5JjKWvfoAkQQ39erXg7nMcgf9rpmkN8CF5VngXJ5HtTrvNDtkDP"
#USER_VIRTUAL3_PUB="EOS7fp4JRZt4i7GW5Ebcg9F4FmSYh3LAMRa6cRcbcqui2Gq4zKKW5"

# USER_VIRTUAL_ACCOUNT4=poiuytre.zar
#USER_VIRTUAL4_PRV="5KURug9mLYK7yrKX2nknQZAiw2AUzCcSznmEstQcpcMkwcbsXdx"
#USER_VIRTUAL4_PUB="EOS5YKpsYBdYAPfQ3duaQNKmXkLJb97s9b7VpYP81bSRJSna7w1BZ"

#VOUCHER_PUB="EOS8UAsFY4RacdaeuadicrkP66JQxPsbNyucmbT8Z4GjwFoytsK9u"
#VOUCHER_PRV="5JKAjH9WH4XnZCEe8v5Wir7awV4YBTVa8KUSqWJbQR6QGtj4yce"

#ESCROW_PUB="EOS8UAsFY4RacdaeuadicrkP66JQxPsbNyucmbT8Z4GjwFoytsK9u"
#ESCROW_PRV="5JKAjH9WH4XnZCEe8v5Wir7awV4YBTVa8KUSqWJbQR6QGtj4yce"

#BLACQMARKET_PUB="EOS8UAsFY4RacdaeuadicrkP66JQxPsbNyucmbT8Z4GjwFoytsK9u"
#BLACQMARKET_PRV="5JKAjH9WH4XnZCEe8v5Wir7awV4YBTVa8KUSqWJbQR6QGtj4yce"

echo
sleep 1






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

# Paths
export NVE_ROOT=~/TCD/nodeos-mve
export NVE_SCRIPTS=${NVE_ROOT}/scripts
export EOSIO_CONTRACTS_ROOT=${NVE_ROOT}/contracts

#PROJECT_HOME=~/Telos-swaps/swaps
#MY_CONTRACTS_BUILD=$PROJECT_HOME/contracts
#MY_SCRIPTS=$PROJECT_HOME/scripts



echo -e "${GREEN}===== Folders${NC}"
echo -e "${CYAN}NVE_ROOT = ${NVE_ROOT}${NC}"
echo -e "${CYAN}NVE_SCRIPTS = ${NVE_SCRIPTS}${NC}"
echo -e "${CYAN}EOSIO_CONTRACTS_ROOT = ${EOSIO_CONTRACTS_ROOT}${NC}"
#echo -e "${CYAN}PROJECT_HOME = ${PROJECT_HOME}${NC}"
#echo -e "${CYAN}MY_CONTRACTS_BUILD = ${MY_CONTRACTS_BUILD}${NC}"
#echo -e "${CYAN}MY_SCRIPTS = ${MY_SCRIPTS}${NC}"





#clear
#./compile_ref.sh
#echo
#./restart.sh

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#DIR="$( cd ../ > /dev/null  && pwd )"
#EOSIO_CONTRACTS_ROOT=${DIR}/eosio.contracts/build/contracts
#EOSIO_OLD_CONTRACTS_ROOT=${DIR}/old.contracts/eosio.contracts/build/contracts
#MY_CONTRACTS_BUILD=${DIR}

NODEOS_HOST="127.0.0.1"
NODEOS_PROTOCOL="http"
NODEOS_PORT="8888"
NODEOS_LOCATION="${NODEOS_PROTOCOL}://${NODEOS_HOST}:${NODEOS_PORT}"

# temp keosd setup
WALLET_DIR=${DIR}/temp-eosio-wallet
UNIX_SOCKET_ADDRESS=$WALLET_DIR/keosd.sock
WALLET_URL=unix://$UNIX_SOCKET_ADDRESS

function cleos() { command cleos --url=${NODEOS_LOCATION} --wallet-url=$WALLET_URL "$@"; echo $@; }
on_exit(){
  echo -e "${CYAN}cleaning up temporary keosd process & artifacts${NC}";
  kill -9 $TEMP_KEOSD_PID &> /dev/null
  rm -r $WALLET_DIR
}

trap my_trap INT
trap my_trap SIGINT


# start temp keosd
rm -rf $WALLET_DIR
mkdir $WALLET_DIR
keosd --wallet-dir=$WALLET_DIR --unix-socket-path=$UNIX_SOCKET_ADDRESS &> /dev/null &
TEMP_KEOSD_PID=$!
sleep 1

# create temp wallet
cleos wallet create --file $WALLET_DIR/.temp_keosd_pwd
PASSWORD=$(cat $WALLET_DIR/.temp_keosd_pwd)
cleos wallet unlock --password="$PASSWORD"

#NET_PUB="EOS8HuvjfQeUS7tMdHPPrkTFMnEP7nr6oivvuJyNcvW9Sx5MxJSkZ"
#NET_PRV="5JS9bTWMc52HWmMC8v58hdfePTxPV5dd5fcxq92xUzbfmafeeRo"

COOL_PUB="EOS833HgCT3egUJRDnW5k3BQGqXAEDmoYo6q1s7wWnovn6B9Mb1pd"
COOL_PRV="5JFLPVygcZZdEno2WWWkf3fPriuxnvjtVpkThifYM5HwcKg6ndu"

USR_PUB="EOS8UAsFY4RacdaeuadicrkP66JQxPsbNyucmbT8Z4GjwFoytsK9u"
USR_PRV="5JKAjH9WH4XnZCEe8v5Wir7awV4YBTVa8KUSqWJbQR6QGtj4yce"

CLAIM_PUB="EOS77s45YiM8xhq7MWxuTdERBDn3ntHG8DTtcdwNVR2Srhxg5SZk7"
CLAIM_PRV="5HrFtXh3ycvp2rSrpJb6bHJimB14adD6WXuQW4LnXA5posqpfAG"

PAYFEE_PUB="EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3"
PAYFEE_PRV="5KgKxmnm8oh5WbHC4jmLARNFdkkgVdZ389rdxwGEiBdAJHkubBH"

echo

# EOSIO system-related keys
echo -e "${CYAN}---------------------------SYSTEM KEYS---------------------------${NC}"
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
cleos wallet import --private-key 5JgqWJYVBcRhviWZB3TU1tN9ui6bGpQgrXVtYZtTG2d3yXrDtYX
cleos wallet import --private-key 5JjjgrrdwijEUU2iifKF94yKduoqfAij4SKk6X5Q3HfgHMS4Ur6
cleos wallet import --private-key 5HxJN9otYmhgCKEbsii5NWhKzVj2fFXu3kzLhuS75upN5isPWNL
cleos wallet import --private-key 5JNHjmgWoHiG9YuvX2qvdnmToD2UcuqavjRW5Q6uHTDtp3KG3DS
cleos wallet import --private-key 5JZkaop6wjGe9YY8cbGwitSuZt8CjRmGUeNMPHuxEDpYoVAjCFZ
cleos wallet import --private-key 5Hroi8WiRg3by7ap3cmnTpUoqbAbHgz3hGnGQNBYFChswPRUt26
cleos wallet import --private-key 5JbMN6pH5LLRT16HBKDhtFeKZqe7BEtLBpbBk5D7xSZZqngrV8o
cleos wallet import --private-key 5JUoVWoLLV3Sj7jUKmfE8Qdt7Eo7dUd4PGZ2snZ81xqgnZzGKdC
cleos wallet import --private-key 5Ju1ree2memrtnq8bdbhNwuowehZwZvEujVUxDhBqmyTYRvctaF
cleos wallet import --private-key 5JsRjdLbvRKGDKpVLsKuQr57ksLf4B8bpQEVFb5D1rDiPievt88
cleos wallet import --private-key 5J3JRDhf4JNhzzjEZAsQEgtVuqvsPPdZv4Tm6SjMRx1ZqToaray
echo
echo -e "${CYAN}---------------------------BANCOR KEYS---------------------------${NC}"
#cleos wallet import --private-key $NET_PRV

cleos wallet import --private-key $COOL_PRV
cleos wallet import --private-key $USR_PRV
cleos wallet import --private-key $CLAIM_PRV
cleos wallet import --private-key $PAYFEE_PRV

# Create system accounts
echo
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
#sleep 1

if [[ $EOSVERSION == 2 ]]; then
  #load old boot contract and activate
  echo -e "${CYAN}-----------------------ACTIVATE OLD BOOT SEQ-----------------------${NC}"
  cleos set contract eosio $EOSIO_OLD_CONTRACTS_ROOT/eosio.boot/
  cleos push transaction '{"delay_sec":0,"max_cpu_usage_ms":0,"actions":[{"account":"eosio","name":"activate","data":{"feature_digest":"299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"},"authorization":[{"actor":"eosio","permission":"active"}]}]}'
fi
sleep 2 #NB needs time to before moving on

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
cleos push action eosio.token issue '[ "eosio", "10000000000.0000 TLOS", "Genesis tokens" ]' -p eosio
echo -e "      TLOS TOKEN ISSUED"
if [[ $EOSVERSION == 1 ]]; then
  cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.bios/
  echo -e "      BIOS SET"
fi
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


sleep 1
on_exit
echo -e "${GREEN}--> Done${NC}"
