#!/usr/bin/env bash

# Default settings
## Java
JAVA=`which java`

[ -d "$WORKSPACE" ] || { echo workspace "$WORKSPACE" does not exist; exit -1; }

[ -d "$WORKSPACE/logs" ] || mkdir "$WORKSPACE/logs"

## Client-API
CLIENTAPI_MODULE=fnf.clientapi
CLIENTAPI_FOLDER=fnf.clientapi

## Simulator Lib
SIMULIB_MODULE=fnf.simulib
SIMULIB_FOLDER=fnf.simulib

## Kobayashi
KOBAYASHI_MODULE=fnf.kobayashi
KOBAYASHI_FOLDER=fnf.kobayashi

## Relay server
RELAY_PORT=8090
RELAY_MODULE=fnf.relay
RELAY_FOLDER=fnf.relay

## Team server
TEAMSERVER_PORT=8081
TEAMSERVER_MODULE=teamserver
TEAMSERVER_FOLDER=TeamServer

## Competition server
COMPETITIONS_PORT=8082
COMPETITIONS_MODULE=competition
COMPETITIONS_FOLDER=competitions

## Config server
CONFIGSERVER_PORT=8888
CONFIGSERVER_MODULE=configserver
CONFIGSERVER_FOLDER=configserver

## Configuration
CONFIG_FOLDER=configuration

## Simulator server
SIMULATOR_PORT=8083
SIMULATOR_MODULE=fnf.simulator
SIMULATOR_FOLDER=fnf.simulator
