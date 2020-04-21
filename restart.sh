#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
NODEOS=$DIR/nodeos
DATADIR=$NODEOS/data

$DIR/stop.sh

rm $NODEOS/nodeos.log
rm $NODEOS/nodeos.tty
rm -r $NODEOS/data
rm -r $NODEOS/protocol_features

$DIR/start.sh
