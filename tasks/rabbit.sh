#!/usr/bin/env bash

rabbitMqDaemon="/etc/init.d/rabbitmq-server"

if [ -e "$rabbitMqDaemon" ]
then
	echo $rabbitMqDaemon found, starting daemon
	sudo $rabbitMqDaemon restart	
else
	echo $rabbitMqDaemon does not exist. You are missing a rabbit installation or are using a different name
	exit -1
fi
