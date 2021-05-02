# Get all Workload Identity Service Accounts

echo "[+] Fetching Workload Identity GSA names..."
google_service_accts=$(
kubectl get sa --all-namespaces -o json \
  | jq '.items[] | .metadata.annotations."iam.gke.io/gcp-service-account" | select(.)' \
  | tr -d '"' \
  | sort \
  | uniq
)

echo "[+] Getting GSA Role Bindings..."
for GSA in ${google_service_accts[@]}; do
    base_name=$(echo "${GSA}" | cut -d'@' -f1)
    gcloud projects get-iam-policy rigup-production \
      --flatten="bindings[].members" \
      --format="table[box,title='${base_name}',no-heading](bindings.role)" \
      --filter="bindings.members:${GSA}"
done
