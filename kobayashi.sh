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
	checkout_module ${KOBAYASHI_FOLDER}
	build_module ${KOBAYASHI_FOLDER}
fi

if [ "${stop}" = "yes" ]
then
	shutdown_process ${KOBAYASHI_MODULE}
fi

if [ "${run}" = "yes" ]
then
	echo
  echo "starting kobayashi test driver"
  cd ${WORKSPACE}/${KOBAYASHI_FOLDER}
  nohup java -jar target/${KOBAYASHI_MODULE}-1.0-SNAPSHOT.jar \
      --javapilot.relayUrl=ws://localhost:${RELAY_PORT}/ws/rest/messages \
      > ${WORKSPACE}/logs/kobayashi.log 2>&1 &
  check_process_started ${KOBAYASHI_MODULE}
fi
