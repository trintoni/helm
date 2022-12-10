# Anderson Trintoni
# Link da web https://loft.sh/blog/harbor-kubernetes-self-hosted-container-registry/ 
# Instalacao do Harbor em Kubernetes - Minikube
# Testado no Ubuntu 20.04
# Necessário pacotes:
# kubectl - Que devera ser instalado antes desse script
# expect - Quer será instalado por esse script
echo -n "

Seu usuário: $USER, deve obrigatoriamente ter permissões de sudo para o script funcionar

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
echo -n "Neste momento voce deverá criar a entrada no seu /etc/hosts para acesso ao harbor via browser 
O nome do host será core.harbor.domain ou outro que voce queira

Entrada no /etc/hosts à adicionar:

$(minikube ip) core.harbor.domain
"

