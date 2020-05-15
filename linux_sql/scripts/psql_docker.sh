#!/bin/bash

#Assign Variables to Arguments
action=$1 #Create, Stop, Start
db_username=$2
db_password=$3

#Start Docker if not done so already
if systemctl status docker || systemctl start docker
then
  echo "Docker is Active"
fi

#Create Container Clause
if [ $action = "create" ]; then
  #Check if Container is Already in Use
  if  [ `docker container ls -a -f name=jrvs-psql | wc -l` == 2 ]; then
    echo "Error: Container name is already in use"
    exit 1
  fi
  #Check if Username($2) and Password($3) argument are filled in
  if [ -z "$db_username" ] || [ -z "$db_password" ]; then
    echo "Error: Please fill username and password correctly"
    exit 1
  fi
  # Check if container created
  if [ `docker container ls -a -f name=jrvs-psql | wc -l` == 2 ]; then
      echo "Error: Container already created"
      exit 1
  fi
  #Create Volume and Container
  docker volume create pgdata
  docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  echo "Container was successfully created!"
  exit $?
fi

#Start Container
if [ $action = "start" ]; then
  docker container start jrvs-psql
  exit $?
fi

#Stop Container
if [ $action = "stop" ]; then
  docker container stop jrvs-psql
  exit $?
fi

# Argument is Invalid
echo "Error: You must enter create, start or stop in argument"
exit 1
