#!/usr/bin/bash
LOG_DIR=$WORKSPACE/logs/
nohup mongod > $LOG_DIR/mongo.log 2>&1 &
nohup rabbitmq-server >$LOG_DII/rabbit.log 2>&1 &