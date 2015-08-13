#!/usr/bin/env bash

. ./config.sh
. ./functions.sh

check_has_changes $PWD

if [ -d ../${KOBAYASHI_FOLDER} ]
then
	check_has_changes ../${KOBAYASHI_FOLDER}
fi

if [ -d ../${RELAY_FOLDER} ]
then
	check_has_changes ../${RELAY_FOLDER}
fi

if [ -d ../${TEAMSERVER_FOLDER} ]
then
	check_has_changes ../${TEAMSERVER_FOLDER}
fi

if [ -d ../${COMPETITIONS_FOLDER} ]
then
	check_has_changes ../${COMPETITIONS_FOLDER}
fi

if [ -d ../${CONFIGSERVER_FOLDER} ]
then
	check_has_changes ../${CONFIGSERVER_FOLDER}
fi

if [ -d ../${CONFIG_FOLDER} ]
then
	check_has_changes ../${CONFIG_FOLDER}
fi

if [ -d ../${SIMULATOR_FOLDER} ]
then
	check_has_changes ../${SIMULATOR_FOLDER}
fi
