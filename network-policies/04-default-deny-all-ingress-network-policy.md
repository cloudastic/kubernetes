


* Network Policies are namespaced resources. 

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

```
kubectl exec -it -n frontend webapp -- curl -m 3 $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")
```

```
kubectl exec -it -n backend mysql -- curl -m 3 $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")
```

Both the requests are now timed out and this clearly indicates that the incoming traffic is now blocked on the middleware namespace.