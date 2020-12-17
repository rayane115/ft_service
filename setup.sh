######################################
# CONFIGURE METALLB AS LOAD-BALANCER #
######################################
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
#cp srcs/metallb/metallb-conf.yaml srcs/metallb/config.yaml
#sed -ie "s/MINIKUBE_IP/$IP/g" srcs/metallb/config.yaml
kubectl apply -f srcs/metallb/metallb-conf.yaml
