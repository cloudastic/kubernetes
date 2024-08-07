


### Default deny all ingress
```
cat <<EOF | kubectl create -f -n middleware -
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

