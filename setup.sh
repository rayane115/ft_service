#!/bin/bash

_BLUE='\033[34m'
_GREEN='\033[32m'

######################################
#      LANCEMENT DE MINIKUBE         #
######################################

minikube delete 
minikube start --vm-driver=docker 
######################################
# CONFIGURE METALLB AS LOAD-BALANCER #
######################################
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml 
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 

kubectl apply -f srcs/metallb/metallb-conf.yaml 
######################################
#          Docker build              #
######################################
eval $(minikube docker-env)
echo "\e[93mBuilding Nginx:\e[0m"
docker build -t my_nginx srcs/nginx/
echo "\e[93mBuilding MySQL:\e[0m" 
docker build -t my_mysql srcs/mySQL/
echo "\e[93mBuilding Phpmyadmin:\e[0m"
docker build -t my_phpmyadmin srcs/phpmyadmin
echo "\e[93mBuilding Wordpress:\e[0m"
docker build -t my_wordpress srcs/wordpress
eval $(minikube docker-env -u)
######################################
#          Config YAML               #
######################################
echo "\e[91mDeployement NGINX:\e[0m" \n
kubectl apply -f nginx-pod.yaml
echo "\e[91mDeployement MYSQL:\e[0m" 
kubectl apply -f mySQL-pod.yaml
echo "\e[91mDeployement PHPMYADMIN:\e[0m" 
kubectl apply -f php-pod.yaml
echo "\e[91mDeployement WORDPRESS:\e[0m" 
kubectl apply -f wordpress-pod.yaml

######################################
#        Dashboard kubernetes        #
######################################

 clear && echo -ne "$_GREEN
	        ╔══════════════════════╗
chargement	║██████████████████████║  (100%)
	        ╚══════════════════════╝\n"
xterm -hold -e "minikube dashboard" &

echo -ne 	"\n\n\033[1;36m
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
e)
                                                                                  \n\n"