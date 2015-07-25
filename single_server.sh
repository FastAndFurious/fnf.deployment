#!/usr/bin/env bash



ensure_process () {
    sleep 2
    line=`ps -ef | grep target/$1 | grep -v grep`
    java=`echo ${line} | tr -s " " | cut -d " " -f 8`
    if [ "${java}" = "${JAVA}" ]
    then
        echo $line
        echo $1 up and running.
    else
        echo failed to start $1
        exit -1
    fi
}

# dont build
build=no


shutdown=no

while getopts b:r:s: opt; do
  case ${opt} in
  b)
      build=$OPTARG
      ;;
  c)
      component=$OPTARG
      ;;
  s)
      shutdown=$OPTARG
      ;;
  esac
done
shift $((OPTIND - 1))




if [ "${shutdown}" = "yes" ]
then
    echo "Shutting down all servers"
else
    if [ "$build" = "yes" ]
    then
        if [ -d "$WORKSPACE" ]
        then
            echo Using WORKSPACE: ${WORKSPACE}
            [ -d ${WORKSPACE}/logs ] || mkdir ${WORKSPACE}/logs
            cd ${WORKSPACE}
        else
            echo WORKSPACE not set.
            echo "Please do export WORKSPACE=<directory where git repos can be found or created>"
            exit -1
        fi

        echo
        echo     Now collecting sources from git
        echo
        for directory in Kobayashi Relay TeamServer competitions configuration configserver simulator
        do
            if ! [ -d ${directory} ]
            then
                echo ${directory} does not exist. Cloning git repo...
                cd ${WORKSPACE} && git clone https://github.com/FastAndFurious/${directory}.git
            else
                echo ${directory} exists. Good.
            fi
        done


        echo
        echo     Now building all server components
        echo
        for directory in Kobayashi Relay TeamServer competitions configserver simulator
        do
            echo ${directory} exists, going to build the executable.
            if [ "${directory}" = "simulator" ]
            then
                echo running bower explicitly. Somehow, maven does not realize the necessity
                cd ${WORKSPACE}/simulator/src/main/resources/public/
                bower install

            elif [ "${directory}" = "competitions" ]
            then
                echo running bower explicitly. Somehow, maven does not realize the necessity
                cd ${WORKSPACE}/competitions
                bower install
                cp -rf bower_components/ src/main/webapp/bower_components
            fi

            cd ${WORKSPACE}/${directory}
            mvn clean package
        done
    fi
fi


JAVA=`which java`

echo
echo     Now shutting down servers that might be running
echo =========================================================
echo
for service in carrera.kobayashi relay teamserver competitions configserver carrera.simulator
do
    line=`ps -ef | grep target/${service} | grep -v grep`

    java=`echo ${line} | tr -s " " | cut -d " " -f 8`

    if [ "${java}" = "${JAVA}" ]
    then
        echo ${line}
        echo ${service} server is still running. Shutting down.
        pid=`echo ${line} | tr -s " " | cut -d " " -f 2`
        kill ${pid}
    else
        echo ${service} is not up. Good.
    fi
done
sleep 4


CONFIG_PORT=8888
TEAMSERVER_PORT=8081
COMPETITIONS_PORT=8082
SIMULATOR_PORT=8083
RELAY_PORT=8090

if [ "${shutdown}" != "yes" ]
then

    echo
    echo     Now bringing them all back up again
    echo ===========================================

    echo
    echo starting config server
    cd ${WORKSPACE}/configserver
    nohup java -jar target/configserver-0.0.1-SNAPSHOT.jar \
        --spring.cloud.config.server.git.uri=file://$WORKSPACE/configuration \
        --server.port=${CONFIG_PORT} > ${WORKSPACE}/logs/configserver.log 2>&1 &
    ensure_process configserver

    echo
    echo starting relay server
    cd ${WORKSPACE}/Relay
    nohup java -jar target/relay-0.0.1-SNAPSHOT.war \
        --relay.roundTimesRestUrl=http://localhost:8082/api/roundTimes \
        --server.port=${RELAY_PORT} > ${WORKSPACE}/logs/relay.log 2>&1 &
    ensure_process relay

    echo
    echo starting simulator server
    cd ${WORKSPACE}/simulator
    nohup java -jar target/carrera.simulator-0.1.0-SNAPSHOT.war --spring.profiles.active=dev \
        --simulator.relayUrl=ws://localhost:${RELAY_PORT}/ws/rest/messages \
        --server.port=${SIMULATOR_PORT} > ${WORKSPACE}/logs/simulator.log 2>&1 &
    ensure_process carrera.simulator

    echo
    echo starting kobayashi test driver
    cd ${WORKSPACE}/Kobayashi
    nohup java -jar target/carrera.kobayashi-1.0-SNAPSHOT.jar \
        --javapilot.relayUrl=ws://localhost:${RELAY_PORT}/ws/rest/messages \
        > ${WORKSPACE}/logs/kobayashi.log 2>&1 &
    ensure_process carrera.kobayashi

    echo
    echo starting team server
    cd ${WORKSPACE}/TeamServer
    nohup java -jar target/teamserver-0.0.1-SNAPSHOT.war \
        --links.competitionserver=http://localhost:${COMPETITIONS_PORT} \
        --server.port=${TEAMSERVER_PORT} > ${WORKSPACE}/logs/teamserver.log 2>&1 &
    ensure_process teamserver

    echo
    echo starting competition server
    cd ${WORKSPACE}/competitions
    nohup java -jar target/competition-0.0.1-SNAPSHOT.war \
        --competitions.relayUrl=http://localhost:${RELAY_PORT}/ws/rest/raceTracks/ \
        --server.port=${COMPETITIONS_PORT} > ${WORKSPACE}/logs/competitions.log 2>&1 &
    ensure_process competition

fi
