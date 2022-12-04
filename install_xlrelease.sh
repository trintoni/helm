which kubectl
if [ $? = 1 ];then
    echo "Por Favor instale o kubectl"
fi
echo "Habilitando o ingress ao minikube"
minikube addons enable ingress
echo "Criando o namespace xlrelease"
kubectl namespace xlrelease
echo "Criando o StorageClass"
kubectl apply -f storageclass.yaml -n xlrelease
echo "Criando o PVC"
kubectl apply -f pvc.yaml -n xlrelease
echo "Criando o deploy"
kubectl apply -f deployxl.yaml -n xlrelease
echo "Criando o services"
kubectl apply -f services.yaml -n xlrelease
echo "Criando o Ingress"
kubectl apply -f ingress.yaml -n xlrelease