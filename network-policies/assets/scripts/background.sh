cat << 'EOF' > ./validate_connectivity.sh
#!/bin/bash

BOLD='\033[1m'
UL='\033[4m'
RESET='\033[0m'

SUCCESS_ICON="✅"
FAILURE_ICON="❌"
SEPARATOR="---------------------------"

# Input array of source and target pods
array=("frontend:webapp:middleware:middleware" "frontend:webapp:backend:mysql" "middleware:middleware:frontend:webapp" "middleware:middleware:backend:mysql" "backend:mysql:frontend:webapp" "backend:mysql:middleware:middleware")

echo -e "\n\n${BOLD}${UL}############ Validating connectivity between pods across the namespace ############${RESET}\n"
for element in "${array[@]}"; do
  IFS=':' read -r -a parts <<< "$element"
  echo "kubectl exec -it -n ${parts[0]} ${parts[1]} -- curl -s -m 2 \$(kubectl get pods ${parts[3]} -o wide -n ${parts[2]} -o jsonpath=\"{.status.podIP}\")"
  kubectl exec -it -n "${parts[0]}" "${parts[1]}" -- curl -s -m 2 "$(kubectl get pods "${parts[3]}" -o wide -n "${parts[2]}" -o jsonpath="{.status.podIP}")"
  if [ $? -eq 0 ]; then
    echo -e "${SUCCESS_ICON} Connection from '${parts[0]}':'${parts[1]}' ==> '${parts[2]}':'${parts[3]}' ${BOLD}Successful${RESET}"
  else
    echo -e "${FAILURE_ICON} Connection from '${parts[0]}':'${parts[1]}' ==> '${parts[2]}':'${parts[3]}' ${BOLD}Failed${RESET}"
  fi
  echo "$SEPARATOR"
done

echo -e "\n\n"
EOF
chmod +x ./validate_connectivity.sh
