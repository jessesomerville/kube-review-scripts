PROJECT=rigup-production

LOG="cloudaudit.googleapis.com%2Factivity"
FILTER="logName=\"projects/${PROJECT}/logs/${LOG}\" "\
"resource.type=\"k8s_cluster\""

gcloud logging read "${FILTER}" \
  --freshness=1h \
  --project=${PROJECT} \
  --format=json \
| jq --raw-output '.[].protoPayload.methodName' \
| sort \
| uniq