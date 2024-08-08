# Kubernetes default network behaviour

* Each Pod in the cluster gets a unique IP address.
* Containers within a pod share the same network namespace that includes the IP, Port and the MAC address. 
* A container within a multi-container pod can reach other containers within the pod through `localhost`.
* By default, All Inbound and Outbound connections are allowed for a Pod.

## default network communication within single Namespace
[<img src="img/kubernetes-default-communication-single-ns.gif" width="60%" height="60%" />](img/kubernetes-default-communication-single-ns.gif)

## default network communication across different Namespaces
[<img src="img/kubernetes-default-communication-multiple-ns.gif" width="80%" />](img/kubernetes-default-communication-multiple-ns.gif)

## Demo

Now that we have already created the necessary resources, lets try to establish connection between different pods and see if that works.

## Check the IP Address of each pods
```
kubectl get pods -A -o wide --field-selector=metadata.namespace!=kube-system
```
Notice that each pods are assigned with a unique IP address. 

## Connect from webapp to middleware pod
```
kubectl exec -it -n frontend webapp -- curl $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")
```

## Connect from webapp to mysql pod
```
kubectl exec -it -n frontend webapp -- curl $(kubectl get pods mysql -o wide -n backend -o jsonpath="{.status.podIP}")
```

## Connect from middleware to webapp pod
```
kubectl exec -it -n middleware middleware -- curl $(kubectl get pods webapp -o wide -n frontend -o jsonpath="{.status.podIP}")
```

## Connect from middleware to mysql pod
```
kubectl exec -it -n middleware middleware -- curl $(kubectl get pods mysql -o wide -n backend -o jsonpath="{.status.podIP}")
```

## Connect from mysql to middleware pod
```
kubectl exec -it -n backend mysql -- curl $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")
```

## Connect from mysql to webapp pod
```
kubectl exec -it -n backend mysql -- curl $(kubectl get pods webapp -o wide -n frontend -o jsonpath="{.status.podIP}")
```

This demonstrates that we can establish connections between any pods in any namespaces across the entire cluster. The same is true even if all these pods co-exists in the same namespace or its spread across different nodes that form a cluster.




