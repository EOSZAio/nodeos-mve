#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
NODEOS=$DIR/nodeos
DATADIR=$NODEOS/data

$DIR/stop.sh

nodeos -e -p eosio \
--max-transaction-time=2000 \
--data-dir $DATADIR \
--config-dir $NODEOS \
--contracts-console \
--protocol-features-dir $NODEOS/protocol_features \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::history_plugin \
--plugin eosio::history_api_plugin \
--http-validate-host=false \
--verbose-http-errors >> $NODEOS/nodeos.tty 2>$NODEOS/nodeos.log & echo $! > $NODEOS/nodeos.pid

sleep 5

curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq
