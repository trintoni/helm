# Anderson Trintoni
# Instalacao do Consul no Kubernetes - Minikube
# Testado no Ubuntu 20.04
# Necessário pacotes:
# kubectl - Que devera ser instalado antes desse script
echo -n "


1 - Este script adicionará o repositório helm hashicorp 
2 - Criará o namespace "consul"
3 - Irá instalar o deployment, pods, services do consul 
4 - Criará o port-forward para acesso externo do consul

"

helm repo add hashicorp https://helm.releases.hashicorp.com
kubectl create namespace consul
helm install consul hashicorp/consul --set global.name=consul --create-namespace --namespace consul

running_consul=$(kubectl get pods -n consul| grep -w Running | wc -l)
while [ $running_consul -ge 2 ];do
	running_consul=$(kubectl get pods -n consul| grep -w Running | wc -l)
	echo "Aguardando PODs subirem..."
	sleep 3
	if [ $running_consul -eq 3 ];then
		kubectl apply -f consul-ingress.yaml
		exit
	fi
done
