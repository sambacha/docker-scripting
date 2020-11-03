#!/bin/bash
$DOCKER_IMAGE=container_name


while getopts ":hdpt" opt; do
  case ${opt} in
    h )
      printf "USAGE: ./spinup.sh [OPTION]... \n\n" 
      printf "-h for HELP, -d for DEV, -p for PROD, or -t for TEARDOWN \n\n"  
      exit 1
      ;;
    d )
      # Rebuild image $DOCKER_IMAGE
      docker-compose build --no-cache

      # Create $DOCKER_IMAGE-network bridge network for container(s) to communicate
      docker network create --driver bridge $DOCKER_IMAGE-network

      # Spin up $DOCKER_IMAGE container
      docker run -d --name $DOCKER_IMAGE --restart always -p 8080:80 -v $DOCKER_IMAGE_home:/var/www/html --network $DOCKER_IMAGE-network $DOCKER_IMAGE:latest

      exit 1
      ;;
    p )
      # Rebuild image
      docker-compose build

      # Spin up container
      docker-compose up -d

      exit 1
      ;;
    t )
      # If $DOCKER_IMAGE container is running, turn it off.
      running_app_container=`docker ps | grep $DOCKER_IMAGE | wc -l`
      if [ $running_app_container -gt "0" ]
      then
        docker kill $DOCKER_IMAGE
      fi

      # If turned off $DOCKER_IMAGE container exists, remove it.
      existing_app_container=`docker ps -a | grep $DOCKER_IMAGE | grep Exit | wc -l`
      if [ $existing_app_container -gt "0" ]
      then
        docker rm $DOCKER_IMAGE
      fi

      # If image for $DOCKER_IMAGE exists, remove it.
      existing_app_image=`docker images | grep $DOCKER_IMAGE | wc -l`
      if [ $existing_app_image -gt "0" ]
      then
        docker rmi $DOCKER_IMAGE
      fi

      # If $DOCKER_IMAGE_home volume exists, remove it.
      existing_app_volume=`docker volume ls | grep $DOCKER_IMAGE_home | wc -l`
      if [ $existing_app_volume -gt "0" ]
      then
        docker volume rm $DOCKER_IMAGE_home
      fi

      # If $DOCKER_IMAGE-network network exists, remove it.
      existing_hquinnnet_network=`docker network ls | grep $DOCKER_IMAGE-network | wc -l`
      if [ $existing_hquinnnet_network -gt "0" ]
      then
        docker network rm $DOCKER_IMAGE-network
      fi

      exit 1
      ;;
    \? )
      printf "Invalid option: %s" "$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

printf "USAGE: ./spinup.sh [OPTION]... \n\n" 
printf "-h for HELP, -d for DEV, -p for PROD, or -t for TEARDOWN \n\n" 
exit 1