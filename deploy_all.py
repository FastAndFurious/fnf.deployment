#!/usr/bin/env python
import subprocess
from docker import utils
from docker import Client
import os

HOME = "/home/wolfgang"
modules = ["configserver", "hackathon2015"]
workspaces = HOME + "/workspaces"
client = Client(base_url='unix://var/run/docker.sock')

configserver_port_bindings = {8888: 8888}


# return what the process actually returned
def x(cmd):
    return subprocess.call(cmd, shell=True)


# return the output of the process
def r(*args):
    return subprocess.check_output(args, shell=True)


def is_git():
    result = x("test -d .git")
    return result == 0


def stop_all_containers():
    containers = client.containers()
    if len(containers) > 0:
        print "Stopping containers"
        for container in containers:
            for image in client.images():
                if image['Id'][:12] == container['Image'][:12]:
                    print "Stopping instance ", container['Id'][:12], " of ", image['RepoTags'][0]
                    client.stop(container)


def stop_and_remove_all_containers():
    stop_all_containers()
    containers = client.containers(all=True)
    if len(containers) > 0:
        print "Stopping containers"
        for container in containers:
            for image in client.images():
                if image['Id'][:12] == container['Image'][:12]:
                    print "Removing container ", container['Id'][:12]
                    client.remove_container(container)


def find_container(container_name):
    containers = client.containers(all=True)
    if len(containers) > 0:
        for container in containers:
            for image in client.images():
                if image['Id'][:12] == container['Image'][:12]:
                    if image['RepoTags'][0][:16] == 'fnf/' + container_name:
                        return container


def find_image(image_id12):
    for image in client.images():
        if image['Id'][:12] == image_id12:
            return image


def deploy_and_start_configserver():
    directory = workspaces + "/" + "configserver"
    print "now in directoy: ", directory
    os.chdir(directory)
    print "Pulling configserver"
    result = r("git pull")
    print result
    print "Building image. That may take a minute or two..."
    new_image_id12 = r(
        'mvn clean package docker:build 2>/dev/null | grep "Successfully built" | cut -d" " -f3').strip()
    print "Docker image:", new_image_id12
    new_image_id = find_image(new_image_id12)['Id'][:12]
    host_config = utils.create_host_config(port_bindings=configserver_port_bindings)
    container = client.create_container(image=new_image_id, host_config=host_config, detach=True)
    client.restart(container)


stop_and_remove_all_containers()

deploy_and_start_configserver()
configserver = find_container('configserver')
print configserver
