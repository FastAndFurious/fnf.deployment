#!/usr/bin/env bash

. ./config.sh
. ./functions.sh

build=yes
stop=yes
run=yes
help=no

cd ${WORKSPACE}

while getopts b:s:r:h: opt; do
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
	h)
		help=yes
		;;
  esac
done
shift $((OPTIND - 1))

if [ "${help}" = "yes" ]
then
	echo
	echo "usage:"
	echo
	echo "-b"
	echo "		Checkout from git (if necessary) and build. Use 'yes' or 'no'. Default is 'yes'"
	echo
	echo "-s"
	echo "		Stop the service if it is running. Use 'yes' or 'no'. Default is 'yes'"
	echo
	echo "-r"
	echo "		Start the service if. Use 'yes' or 'no'. Default is 'yes'"
	exit 0
fi

if [ "${build}" = "yes" ]
then
	checkout_module ${RELAY_FOLDER}
	build_module ${RELAY_FOLDER}
fi

if [ "${stop}" = "yes" ]
then
	shutdown_process ${RELAY_MODULE}
fi

if [ "${run}" = "yes" ]
then
	echo
  echo "starting relay server"
  cd ${WORKSPACE}/${RELAY_FOLDER}
  nohup java -jar target/${RELAY_MODULE}-0.0.1-SNAPSHOT.war \
        --relay.roundTimesRestUrl=http://localhost:8082/api/roundTimes \
        --server.port=${RELAY_PORT} > ${WORKSPACE}/logs/relay.log 2>&1 &
  check_process_started ${RELAY_MODULE}
fi
