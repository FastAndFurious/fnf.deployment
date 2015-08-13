#!/usr/bin/env bash

check_has_changes() {
	currentDir=$PWD
	cd $1
	if ! git status | grep -q "nothing to commit, working directory clean";
	then
		echo "$1 has changes on active branch"
	fi
	cd $currentDir
}

check_process_started() {
  sleep 2
  line=`ps -ef | grep target/$1 | grep -v grep`
  java=`echo ${line} | tr -s " " | cut -d " " -f 8`
  # ps may show the simple name (ubuntu) or the complete path to the executable (Mac)
  if [ "${java}" = "${JAVA}" ] || [  "${java}" = "java" ]
  then
    echo $line
    echo $1 up and running.
  else
    echo failed to start $1
    exit -1
  fi
}

shutdown_process() {
	line=`ps -ef | grep target/$1 | grep -v grep`
  java=`echo ${line} | tr -s " " | cut -d " " -f 8`
  if [ "${java}" = "${JAVA}" ] || [ "${java}" = "java" ]
  then
    echo ${line}
    echo $1 server is still running. Shutting down.
    pid=`echo ${line} | tr -s " " | cut -d " " -f 2`
    kill ${pid}
  else
    echo $1 is not up. Good.
  fi
}

checkout_module() {
	if ! [ -d "$1" ]
  then
      echo $1 does not exist. Cloning git repo...
      cd ${WORKSPACE} && git clone https://github.com/FastAndFurious/$1.git
  else
      echo $1 exists. Good.
  fi
}

build_module() {
	echo $1 exists, going to build the executable.
	if [ "$1" = "simulator" ]
	then
	  echo running bower explicitly. Somehow, maven does not realize the necessity
	  cd ${WORKSPACE}/simulator/src/main/resources/public/
	  bower install
	elif [ "$1" = "competitions" ]
	then
		  echo running bower explicitly. Somehow, maven does not realize the necessity
		  cd ${WORKSPACE}/competitions
		  bower install
		  cp -rf bower_components/ src/main/webapp/bower_components
	fi
	cd ${WORKSPACE}/$1
	mvn clean package
}

contains() {
  string="$1"
  substring="$2"
  if test "${string#*$substring}" != "$string"
  then
    return 0
  else
    return 1
  fi
}

is_in_list_or_all() {
	if contains $1 $2;
	then
		return 0
	else
		if [ "$1" = "all" ]
		then
			return 0
		else
			return 1
		fi		
	fi
}

run_script() {
	cd $5
	sh $1 -b $2 -s $3 -r $4
}
