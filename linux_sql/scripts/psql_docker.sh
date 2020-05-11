#!/bin/bash

#Start Docker if not done so already
if systemctl status docker || systemctl start docker
then
  echo "Docker is Active"
  echo $1

fi

#Create Container Clause
if [ $1 = "create" ]
then
  #Check if Container is Already in Use
  #var=`docker container ls -a -f name=jrvs-psql | wc -l`
  if  [ `docker container ls -a -f name=jrvs-psql | wc -l` == 2 ]
  then
    echo "Error: Container name is already in use"
    exit 1
  fi

  #Check if Username($2) and Password($3) argument are filled in
  if [ -z "$2" ] || [ -z "$3" ]
  then
    echo "Error: Please fill username and password correctly"
    exit 1
  fi

  db_username=$2
  db_password=$3
  #Create Volume and Container
  docker volume create pgdata
  docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  echo "Container was successfully created!"
  exit 0
fi

# Check if container created
if [ `docker container ls -a -f name=jrvs-psql | wc -l` == 1 ]
then
    echo "Error: Container was not created: Please Create a Container"
    exit 1
fi

#Start Container
if [ $1 == "start" ]
then
  docker container start jrvs-psql
  exit 0
fi

#Stop Container
if [ $1 == "stop" ]
then
  docker container stop jrvs-psql
  exit 0
fi

# If argument is invalid
if  [ $1 != "start" ] || [ $1 != "stop" ]
then
  echo "Error: You must enter start or stop in argument"
  exit 1
fi
