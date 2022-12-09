# Anderson Trintoni
# Link da web https://loft.sh/blog/harbor-kubernetes-self-hosted-container-registry/ 
# Instalacao do Harbor em Kubernetes - Minikube
# Testado no Ubuntu 20.04
# Necessário pacotes:
# kubectl - Que devera ser instalado antes desse script
# expect - Quer será instalado por esse script
echo -n "

Execute este script com SUDO para instalar o harbor
Para seguir a instalação é necessario a instalação do expect (Automatizada no Script)
1 - Este script iniciará o minikube
2 - Habilitará o ingress no minikube
3 - Criará o namespace chamado "harbor"
4 - Adicionará o repositorio do harbor no helm
5 - Adicionará os certificados para conexao TLS 
6 - Executara o script expect automatizando a copia nos pods do minikube.
7 - Após a execução o harbor estará no ar

"
read -p "Deseja continuar (S/N):? " resp
if [ $resp = S ];then
	which kubectl
	if [ $? = 1 ];then
		echo "kubectl não encontrado no seu PATH, ou não instalado. Corrija este problema!"
		exit
	fi
	sudo apt install expect -y
	minikube start
	minikube addons enable ingress
	kubectl create namespace harbor
	sleep 10
	helm repo add harbor https://helm.goharbor.io -n harbor
	helm install my-release harbor/harbor -n harbor
	eval $(minikube docker-env)
	kubectl -n harbor get secrets harbor-ingress -o jsonpath="{.data['ca\.crt']}" | base64 -d > harbor-ca.crt
	scp -o IdentitiesOnly=yes -i $(minikube ssh-key) harbor-ca.crt docker@$(minikube ip):./harbor-ca.crt
	expect script.exp
fi
echo "Aguardando o ambiente subir..."
sleep 20
echo
echo -n "Neste momento criaremos as entradas de nome no seu arquivo local hosts /etc/hosts:
O nome do host será core.harbor.domain

Entrada no /etc/hosts à adicionar:

<IP DO MINIKUBE> core.harbor.domain

"
read -p "Deseja continuar? (S/N):? " resp1
if [ $resp = S ];then
	minikube status | grep "Running"
	if [ $? = 0 ];then
		echo $(minikuke ip) >> /etc/hosts
	fi
fi

