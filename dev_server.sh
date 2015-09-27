#!/usr/bin/env bash

. ./config.sh
. ./functions.sh

build=all
stop=all
run=all
scriptDir=$PWD

cd ${WORKSPACE}

while getopts b:s:r: opt; do
  case ${opt} in
  b)
    build=$OPTARG
    ;;
  s)
    stop=$OPTARG
    ;;
	r)
		run=$OPTARG
		;;
  esac
done
shift $((OPTIND - 1))

# Checkout and Build
if is_in_list_or_all $build $KOBAYASHI_FOLDER;
then
	run_script kobayashi.sh yes no no $scriptDir
fi
if is_in_list_or_all $build $RELAY_FOLDER;
then
	run_script relayserver.sh yes no no $scriptDir
fi
if is_in_list_or_all $build $TEAMSERVER_FOLDER;
then
	run_script teamserver.sh yes no no $scriptDir
fi
if is_in_list_or_all $build $COMPETITIONS_FOLDER;
then
	run_script competitionsserver.sh yes no no $scriptDir
fi
if is_in_list_or_all $build $CONFIGSERVER_FOLDER;
then
	run_script configserver.sh yes no no $scriptDir
fi
if is_in_list_or_all $build $SIMULATOR_FOLDER;
then
	run_script simulatorserver.sh yes no no $scriptDir
fi

if is_in_list_or_all $build $ANALYTICS_FOLDER;
then
	run_script analytics.sh yes no no $scriptDir
fi

# Stop Services
if is_in_list_or_all $stop $KOBAYASHI_FOLDER;
then
	run_script kobayashi.sh no yes no $scriptDir
fi
if is_in_list_or_all $stop $RELAY_FOLDER;
then
	run_script relayserver.sh no yes no $scriptDir
fi
if is_in_list_or_all $stop $TEAMSERVER_FOLDER;
then
	run_script teamserver.sh no yes no $scriptDir
fi
if is_in_list_or_all $stop $COMPETITIONS_FOLDER;
then
	run_script competitionsserver.sh no yes no $scriptDir
fi
if is_in_list_or_all $stop $CONFIGSERVER_FOLDER;
then
	run_script configserver.sh no yes no $scriptDir
fi
if is_in_list_or_all $stop $SIMULATOR_FOLDER;
then
	run_script simulatorserver.sh no yes no $scriptDir
fi
if is_in_list_or_all $stop $ANALYTICS_FOLDER;
then
	run_script analytics.sh no yes no $scriptDir
fi
sleep 4

# Start Services
if is_in_list_or_all $run $CONFIGSERVER_FOLDER;
then
	run_script configserver.sh no no yes $scriptDir
fi
if is_in_list_or_all $run $RELAY_FOLDER;
then
	run_script relayserver.sh no no yes $scriptDir
fi
if is_in_list_or_all $run $SIMULATOR_FOLDER;
then
	run_script simulatorserver.sh no no yes $scriptDir
fi
if is_in_list_or_all $run $KOBAYASHI_FOLDER;
then
	run_script kobayashi.sh no no yes $scriptDir
fi
if is_in_list_or_all $run $TEAMSERVER_FOLDER;
then
	run_script teamserver.sh no no yes $scriptDir
fi
if is_in_list_or_all $run $COMPETITIONS_FOLDER;
then
	run_script competitionsserver.sh no no yes $scriptDir
fi
if is_in_list_or_all $run $ANALYTICS_FOLDER;
then
	run_script analytics.sh no no yes $scriptDir
fi
