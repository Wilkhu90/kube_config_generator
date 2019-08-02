kubernetes_api_endpoint=$1
namespace=$2

kubectl create namespace $namespace
sed -i 's/$NAMESPACE/'$namespace'/g' access.yaml
sed -i 's/$NAMESPACE/'$namespace'/g' kube_config.yaml
kubectl apply -f access.yaml

token=$(kubectl get secret spinnaker-user-token-xxxxx -n spinnaker -o "jsonpath={.data.token}" | base64 -D)
certificate=$(kubectl get secret spinnaker-user-token-xxxxx -n spinnaker -o "jsonpath={.data['ca\.crt']}")

sed -i 's/$KUBERNETES_API_ENDPOINT/'$kubernetes_api_endpoint'/g' kube_config.yaml
sed -i 's/$CERTIFICATE/'$certificate'/g' kube_config.yaml
sed -i 's/$TOKEN/'$token'/g' kube_config.yaml

echo "Please place the output in /root/.kube/config file"
cat kube_config.yaml
