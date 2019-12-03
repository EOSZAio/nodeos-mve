#!/bin/bash

DIR=~/TCD/nodeos-mve
NODEOS=$DIR/nodeos
DATADIR=$NODEOS/data

$DIR/stop.sh

rm $NODEOS/nodeos.log
rm $NODEOS/nodeos.pid
rm $NODEOS/nodeos.tty
rm -r $NODEOS/data
rm -r $NODEOS/protocol_features

$DIR/start.sh
