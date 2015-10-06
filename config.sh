#!/usr/bin/env bash

# Default settings
## Java
JAVA=`which java`

[ -d "$WORKSPACE" ] || { echo workspace "$WORKSPACE" does not exist; exit -1; }

[ -d "$WORKSPACE/logs" ] || mkdir "$WORKSPACE/logs"

[ "$FNF_SERVER" = "" ] && { echo "FNF_SERVER (hostname) not set"; exit -1; }

[ "$MYSQL_HOST" = "" ] && { echo MYSQL_HOST not set; exit -1; }

## Client-API
CLIENTAPI_MODULE=fnf.clientapi
CLIENTAPI_FOLDER=fnf.clientapi

## Simulator Lib
SIMULIB_MODULE=fnf.simulib
SIMULIB_FOLDER=fnf.simulib

## Kobayashi
KOBAYASHI_MODULE=fnf.kobayashi
KOBAYASHI_FOLDER=fnf.kobayashi

## Team server
TEAMSERVER_PORT=8081
TEAMSERVER_MODULE=teamserver
TEAMSERVER_FOLDER=TeamServer

## Competition server
COMPETITIONS_PORT=8082
COMPETITIONS_MODULE=competition
COMPETITIONS_FOLDER=competitions


## Simulator server
SIMULATOR_PORT=8083
SIMULATOR_MODULE=fnf.simulator
SIMULATOR_FOLDER=fnf.simulator

## Analytics server
ANALYTICS_PORT=8084
ANALYTICS_MODULE=fnf.analytics
ANALYTICS_FOLDER=fnf.analytics

## Relay server
RELAY_PORT=8090
RELAY_MODULE=fnf.relay
RELAY_FOLDER=fnf.relay

## Config server
CONFIGSERVER_PORT=8888
CONFIGSERVER_MODULE=configserver
CONFIGSERVER_FOLDER=configserver

## Configuration
CONFIG_FOLDER=configuration
