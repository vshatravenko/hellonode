# HelloNode

## NodeJS HelloNode example for Kubernetes

### Install and start Minikube

Install for MacOSX
```
brew cask install minikube
brew install kubectl
```

Run minikube and set kubeconfig
```
minikube start
kubectl config use-context minikube
```

Configure your docker client to point into minikube docker engine
```
eval $(minikube docker-env)
```

### Git clone this repository and build image

```
git clone https://github.com/helios-technologies/hellonode.git
cd hellonode
```

build the docker image into the minikube engine
```
docker build -t hellonode:1.0 .
docker images
```

Create a new deployment
```
kubectl run hello-node --image=hellonode:1.0 --port=8080
```

Expose the service onto a VM port
```
kubectl expose deployment hello-node --type=NodePort
```

List all resources and curl your service
```
kubectl get all
curl $(minikube service hello-node --url)
```

## GitHub pull requests config

1. Add your api key to `ci/credentials.yml`:
```
github_token: '00000000your000api000token00000000000000000000000'
```
2. Generate ssh keys pair
3. Add github private key
```
github_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  0000000000000000000000000000000000000000000000000000000000000000
  000000private00000000key0000000000000000000000000000000000000000
  00000000000000000000000000000000000000000000000000000000
  -----END RSA PRIVATE KEY-----
```
4. Add your public key to github

