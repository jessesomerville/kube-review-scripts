# Get the Workload Identity Pool for a cluster

CLUSTER=$1

if [[ -z ${CLUSTER} ]]; then
    echo "You must provide the name of the cluster as an argument"
    exit
fi

gcloud container clusters describe $CLUSTER \
  --format="table[box,title='Workload Identity']
  (name,workloadIdentityConfig.workloadPool)"