helm repo add hashicorp https://helm.releases.hashicorp.com
kubectl create namespace consul
helm install consul hashicorp/consul --set global.name=consul --create-namespace --namespace consul
# Habilitando acesso remoto com port foward
kubectl port-forward service/consul-server --namespace consul 8500:8500
