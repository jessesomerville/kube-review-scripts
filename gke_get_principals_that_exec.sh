PROJECT=rigup-production

LOG="cloudaudit.googleapis.com%2Factivity"
FILTER="logName=\"projects/${PROJECT}/logs/${LOG}\" "\
"resource.type=\"k8s_cluster\" "\
"protoPayload.methodName=\"io.k8s.core.v1.pods.exec.create\""

gcloud logging read "${FILTER}" \
  --freshness=7d \
  --project=${PROJECT} \
  --format=json \
| jq --raw-output '.[].protoPayload | .authenticationInfo.principalEmail' \
| sort \
| uniq
