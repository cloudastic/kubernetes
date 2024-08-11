# Deny egress on frontend namespace

In our last demo, we have disabled the `ingress` on the `frontend` namespace., and now we are going to apply the `egress` network policy to restrict the outbound traffic from the `frontend` namespace. 

After applying the below network policy, the pods within the `frontend` namespace is quarantined and wont be able to communicate with any pods on any other namespace. 

[<img src="img/deny-ingress-egress-on-frontend-ns.gif" width="80%" />](img/deny-ingress-egress-on-frontend-ns.gif)

### Deny all egress traffic from frontend namespace
```
cat <<EOF | kubectl create -n frontend -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-egress
spec:
  podSelector: {}
  policyTypes:
  - Egress
EOF
```

Check if you are able to see both the Network policies applied to the `frontend` namespace,

```
kubectl get netpol -n frontend
```

Let us now verify the outbound connectivity from the `frontend` namespace,


## Test Egress from frontend namespace

```
# Test Egress from 'webapp' to 'middleware' pod
kubectl exec -it -n frontend webapp -- curl -m 3 $(kubectl get pods middleware -o wide -n middleware -o jsonpath="{.status.podIP}")

# Test Egress from 'webapp' to 'mysql' pod
kubectl exec -it -n frontend webapp -- curl -m 3 $(kubectl get pods mysql -o wide -n backend -o jsonpath="{.status.podIP}")

```

Since the requests timed out after 3 seconds, it confirms that out `egress` network policy is working as desired.

