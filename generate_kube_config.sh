kubernetes_api_endpoint=$1
cluster_name=$2
namespace=$3

kubectl create namespace $namespace
sed -i 's/$NAMESPACE/'$namespace'/g' access.yaml
kubectl apply -f access.yaml

sa_secret_token_name=$(kubectl get secret -n $namespace | grep "$namespace-user-token" | cut -d ' ' -f 1)

token=$(kubectl get secret $sa_secret_token_name -n $namespace -o "jsonpath={.data.token}" | base64 -d)
certificate=$(kubectl get secret $sa_secret_token_name -n $namespace -o "jsonpath={.data['ca\.crt']}")

sed -i 's/$KUBERNETES_API_ENDPOINT/'$kubernetes_api_endpoint'/g' kube_config.yaml
sed -i 's/$CERTIFICATE/'$certificate'/g' kube_config.yaml
sed -i 's/$TOKEN/'$token'/g' kube_config.yaml
sed -i 's/$CLUSTER_NAME/'$cluster_name'/g' kube_config.yaml
sed -i 's/$NAMESPACE/'$namespace'/g' kube_config.yaml

echo "Please place the output in /root/.kube/config file"
cat kube_config.yaml
