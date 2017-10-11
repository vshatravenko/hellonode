Testing

# NodeJS HelloNode example for Kubernetes

## CI

Try the [ci](/ci) after you have deployed HelloNode.

## Using GCE

### Installing tools

1. Install [google cloud sdk](https://cloud.google.com/sdk/downloads)
2. Log in to [google cloud console](https://console.cloud.google.com/home/dashboard?project=bloomon-dev)
3. Install kubectl:
```console
gcloud components install kubectl
```
4. Get container cluster credentials:
```console
gcloud container clusters get-credentials stage-cluster \
    --zone europe-west1-b --project bloomon-dev
```
5. Check if you can connect: run `kubectl proxy` and visit [localhost:8001/ui](http://localhost:8001/ui) in your browser.
6. Install [helm](https://github.com/kubernetes/helm/blob/master/docs/install.md).

Now you're ready to deploy.

### Deploying with kubectl

Create a new deployment

```console
kubectl run test-hellonode --image=hellonode:1.0 --port=8080
```

Expose the service onto a VM port

```console
kubectl expose deployment test-hellonode --type=LoadBalancer
```

Check if the deployment works

```console
$ kubectl get services
NAME          CLUSTER-IP     EXTERNAL-IP     PORT(S)    AGE
hello-node    <cluster ip>   <external-ip>   8080/TCP   1s
$ curl <external ip>:8080
Hello World!
```

### Deploying with helm

```console
$ helm package chart/hellonode
$ helm install hellonode-0.0.1.tgz --name=test
$ kubectl get pods
NAME                           READY     STATUS    RESTARTS   AGE
test-hellonode-12345           1/1       Running   0          1s
$ curl hello.bloomon.io
Hello World!
```

## Using Minikube

### Install and start Minikube

Install for MacOSX
```console
brew cask install minikube
brew install kubectl
```

Run minikube and set kubeconfig
```console
minikube start
kubectl config use-context minikube
```

Configure your docker client to point into minikube docker engine
```console
eval $(minikube docker-env)
```

### Git clone this repository and build image

```console
git clone https://github.com/helios-technologies/hellonode.git
cd hellonode
```

build the docker image into the minikube engine
```console
docker build -t hellonode:1.0 .
docker images
```

Create a new deployment
```console
kubectl run hello-node --image=hellonode:1.0 --port=8080
```

Expose the service onto a VM port
```console
kubectl expose deployment hello-node --type=NodePort
```

List all resources and curl your service
```console
kubectl get all
curl $(minikube service hello-node --url)
```

