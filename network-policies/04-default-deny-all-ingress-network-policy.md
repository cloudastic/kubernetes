# Default deny all ingress traffic

## Network Policies are namespaced resources. 

Let us now block all the incoming traffic 'ingress' to the middleware namespace.

[<img src="img/deny-incoming-traffic-on-middleware-namespace-2.gif" width="80%" />](img/deny-incoming-traffic-on-middleware-namespace-2.gif)

### Default deny all ingress for middleware namespace
```
cat <<EOF | kubectl create -n middleware -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF
```

Now lets try to connect to the `middleware` pod from both the `webapp` and `mysql` pod.

## [Inbound connection] : Connect from webapp to middleware pod
```
kubectl exec -it -n frontend webapp -- curl -m 3 $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")
```

## [Inbound connection] : Connect from mysql to middleware pod
```
kubectl exec -it -n backend mysql -- curl -m 3 $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")
```

Both the ingress requests have now timed out, clearly indicating that incoming traffic to the `middleware` namespace is blocked. Let us now try to establish outbound connection from the `middleware` pod to other pods in `frontend` and `backend` namespace.


## [Outbound connection] : Connect from middleware to webapp pod
```
kubectl exec -it -n middleware middleware -- curl $(kubectl get pods webapp -o wide -n frontend -o jsonpath="{.status.podIP}")
```

## [Outbound connection] : Connect from middleware to mysql pod
```
kubectl exec -it -n middleware middleware -- curl $(kubectl get pods mysql -o wide -n backend -o jsonpath="{.status.podIP}")
```