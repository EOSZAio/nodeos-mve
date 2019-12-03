#!/usr/bin/env bash
#=================================================================================#
# Config Constants

./restart.sh
clear
echo

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

# CHANGE PATH
EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts

NODEOS_HOST="127.0.0.1"
NODEOS_PROTOCOL="http"
NODEOS_PORT="8888"
NODEOS_LOCATION="${NODEOS_PROTOCOL}://${NODEOS_HOST}:${NODEOS_PORT}"

# temp keosd setup
WALLET_DIR=/tmp/temp-eosio-wallet
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
mkdir $WALLET_DIR
keosd --wallet-dir=$WALLET_DIR --unix-socket-path=$UNIX_SOCKET_ADDRESS &> /dev/null &
TEMP_KEOSD_PID=$!
sleep 2

# create temp wallet
cleos wallet create --to-console

USR_PUB="EOS7ugtAHgxYQUUfRV1ZcVoNT4TPZnUSvrKNEK8jTwEYZ6Lu3zG69"
USR_PRV="5KVcEUkiM3JGyEiVVcGuPJJ9pg8FRpYf4d1JKMjgZ9Kz7yfYT3B"

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
cleos wallet import --private-key $USR_PRV

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
cleos create account eosio eosio.vpay EOS6szGbnziz224T1JGoUUFu2LynVG72f8D3UVAS25QgwawdH983U
cleos create account eosio eosio.rex EOS5tjK2jP9jAd4zUe7DG1SCFGQW95W2KbXcYxg3JSu8ERjyZ6VRf

echo
# Bootstrap new system contracts
echo -e "${CYAN}-----------------------SYSTEM CONTRACTS-----------------------${NC}"
cleos set contract eosio.token $EOSIO_CONTRACTS_ROOT/eosio.token/
cleos set contract eosio.msig $EOSIO_CONTRACTS_ROOT/eosio.msig/
cleos push action eosio.token create '[ "eosio", "100000000000.0000 TLOS" ]' -p eosio.token
echo -e "      TLOS TOKEN CREATED"
cleos push action eosio.token issue '[ "eosio", "10000000000.0000 TLOS", "memo" ]' -p eosio
echo -e "      TLOS TOKEN ISSUED"
cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.bios/
echo -e "      BIOS SET"
cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.system/
echo -e "      SYSTEM SET"
cleos push action eosio setpriv '["eosio.msig", 1]' -p eosio@active
cleos push action eosio init '[0, "4,TLOS"]' -p eosio@active

echo
# Deploy eosio.wrap
echo -e "${CYAN}-----------------------EOSIO WRAP-----------------------${NC}"
cleos system newaccount eosio eosio.wrap EOS7LpGN1Qz5AbCJmsHzhG7sWEGd9mwhTXWmrYXqxhTknY2fvHQ1A --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 50 --transfer
cleos push action eosio setpriv '["eosio.wrap", 1]' -p eosio@active
cleos set contract eosio.wrap $EOSIO_CONTRACTS_ROOT/eosio.wrap/

echo
echo -e "${CYAN}-------------------------INITIALISE REX--------------------------${NC}"
cleos system newaccount eosio testuser1 $USR_PUB --stake-cpu "10 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
cleos system newaccount eosio testuser2 $USR_PUB --stake-cpu "10 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
cleos system newaccount eosio testuser3 $USR_PUB --stake-cpu "10 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
cleos system newaccount eosio testuser4 $USR_PUB --stake-cpu "10 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
cleos system newaccount eosio testuser5 $USR_PUB --stake-cpu "10 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer

cleos system newaccount eosio testproxy $USR_PUB --stake-cpu "10 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
cleos system regproxy testproxy
cleos system voteproducer proxy testuser1 testproxy
cleos system voteproducer proxy testuser2 testproxy
cleos system voteproducer proxy testuser3 testproxy
cleos system voteproducer proxy testuser4 testproxy
cleos system voteproducer proxy testuser5 testproxy

cleos push action eosio.token transfer '["eosio","testuser1","70000000.0000 TLOS","Prepare to deposit in REX"]' -p eosio@active
cleos system rex deposit testuser1 "500.0000 TLOS"
cleos push action eosio.token transfer '["eosio","testuser2","100.0000 TLOS","Prepare to deposit in REX"]' -p eosio@active
cleos system rex deposit testuser2 "100.0000 TLOS"
cleos push action eosio.token transfer '["eosio","testuser3","100.0000 TLOS","Prepare to deposit in REX"]' -p eosio@active
cleos system rex deposit testuser3 "100.0000 TLOS"
cleos push action eosio.token transfer '["eosio","testuser4","410000.0000 TLOS","Prepare to deposit in REX"]' -p eosio@active
cleos system rex deposit testuser4 "410000.0000 TLOS"
cleos push action eosio.token transfer '["eosio","testuser5","100.0000 TLOS","Prepare to deposit in REX"]' -p eosio@active
cleos system rex deposit testuser5 "100.0000 TLOS"

# total_lendable : 62178853.2493 TLOS
# total_rent - initial value : 258.7751 TLOS
cleos system rex lendrex testuser1 "62178853.2493 TLOS"
cleos system rex rentcpu testuser1 testuser1 "258.7751 TLOS" "0.0000 TLOS"

# Cost of resource now
cleos system rex rentcpu testuser2 testuser2 "1.0000 TLOS" "0.0000 TLOS"

# Change total_rent using setrex
cleos push action eosio setrex '["100000.0000 TLOS"]' -p eosio@active

# Cost of resource after setrex, ~0.0% borrowed
cleos system rex rentcpu testuser3 testuser3 "1.0000 TLOS" "0.0000 TLOS"

# Borrow 80% of available TLOS in REX
cleos system rex rentcpu testuser4 testuser4 "410000.0000 TLOS" "0.0000 TLOS"

# After 80% borrowed
cleos system rex rentcpu testuser5 testuser5 "1.0000 TLOS" "10.0000 TLOS"

echo

on_exit
echo -e "${GREEN}--> Done${NC}"
