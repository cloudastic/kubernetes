# Kubernetes default network behaviour

* Each Pod in the cluster gets a unique IP address.
* By default, All Inbound and Outbound connections are allowed for a Pod.

## Demo

Now that we have created the necessary resources already in the earlier section, lets try to establish connection with different pods and see if that works.

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

This demonstrates that we can establish connections between any pods in any namespaces across the entire cluster.

[<img src="img/kubernetes-default-communication.gif" width="80%" />](img/kubernetes-default-communication.gif)



