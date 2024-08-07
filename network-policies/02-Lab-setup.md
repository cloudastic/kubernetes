**02. Lab Set-up**

For the purposes of the demo, We have used the minikube cluster and have chosen the Weavenet CNI (Container Network Interface).

*Pre-Requisites:*
* Download and install minikube on your machine
* Download the "weave-daemonset-k8s.yaml" 

we need to explicitly specify the "CNI" whilst starting the minikube cluster by using the following command, 

```
minikube start --network-plugin=cni --cni=$HOME/Cloudastic/k8s/Network-Policies/weave-daemonset-k8s.yaml --driver docker --mount=true --mount-string=$HOME/Cloudastic/k8s/Network-Policies/:/minikube-host
```

