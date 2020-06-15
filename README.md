# kube-review-scripts

A collection of scripts to facilitate Kubernetes reviews.

###

Get all workloads in the cluster that are using the default service account. This script takes parent objects into consideration and does not output workloads that were created as part of a larger workload (e.g. Pods created by a Deployment won't be output, only the Deployment).
