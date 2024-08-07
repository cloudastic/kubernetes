# Lab Set-up

For the purpose of the demo, We have used the Minikube cluster and have chosen the "Weave Net" CNI (Container Network Interface).

__Note:__ The most recent version of Weave Net available at the time of this recording is v2.8.1

__Pre-Requisites:__
* Download and install minikube on your machine
* Download the "[weave-daemonset-k8s.yaml](https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml)" 

__Note:__ 
* We need to explicitly specify the "CNI" whilst starting the minikube cluster by using the following command, 

```
minikube start --network-plugin=cni --cni=$HOME/Cloudastic/k8s/Network-Policies/weave-daemonset-k8s.yaml --driver docker --mount=true --mount-string=$HOME/Cloudastic/k8s/Network-Policies/:/minikube-host
```

* Do not forget to replace the path in the '--cni' and the '--mount-string' sections to match your local set-up. 

