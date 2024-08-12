# Lab Set-up

For the purpose of this 'Kubernetes Network Policies' demo, We have used the [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download) cluster and chosen the 'Weave Net' CNI (Container Network Interface).

## Pre-Requisites ##
* Download and install [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download) on your machine.
* Download the [weave-daemonset-k8s.yaml](https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml)

__Note:__ We have used the most recent version v2.8.1 of 'Weave Net' available at the time of this recording.

## Start your cluster ##
* We need to explicitly specify the "CNI" whilst starting the minikube cluster by using the following command, 

```
minikube start --network-plugin=cni --cni=$HOME/Cloudastic/k8s/Network-Policies/weave-daemonset-k8s.yaml --driver docker --mount=true --mount-string=$HOME/Cloudastic/k8s/Network-Policies/:/minikube-host
```

* Do not forget to replace the path in the '--cni' and the '--mount-string' sections to match your local set-up. 


## Create resources ##

Now lets create the kubernetes resources as outlined in the diagram below,

[<img src="img/Cluster-setup.jpg" width="80%" />](img/Cluster-setup.jpg)

### Create Namespaces ###
```
kubectl create ns frontend
kubectl create ns middleware
kubectl create ns backend
```

### Create Pods
```
kubectl run webapp --image=nginx -n frontend
kubectl run middleware --image=nginx -n middleware
kubectl run mysql --image=nginx -n backend
```

### Update the default index page for ease of identification
In this step we are modifying the default index pages of the nginx for easy identification. 
```
kubectl exec -it -n frontend webapp -- /bin/bash -c "echo Frontend > /usr/share/nginx/html/index.html"
kubectl exec -it -n middleware middleware -- /bin/bash -c "echo Middleware > /usr/share/nginx/html/index.html"
kubectl exec -it -n backend mysql -- /bin/bash -c "echo Backend > /usr/share/nginx/html/index.html"
```


