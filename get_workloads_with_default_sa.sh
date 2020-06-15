#!/bin/bash

divider="───────────────────────────────────"

function printTable() {
	arr=$1[@]
	workloads=("${!arr}")
	if [ ! -z "$workloads" ]
	then
		name=$2
		nameLen=${#name}
		paddingChar=" "
		titlePadRight=$(expr 35 - $(expr ${#name} / 2))
		if (( $nameLen % 2 ))
		then
			titlePadLeft=$titlePadRight
		else
			titlePadLeft=$(expr $titlePadRight + 1)
		fi


		echo "$divider $divider" | awk '{printf "┌%-35s─%-35s┐\n", $1, $2}'
		echo "$name" | awk '{printf "│%-'"$titlePadRight"'s%s%-'"$titlePadLeft"'s│\n", " ", $1, " "}'
		echo "$divider $divider" | awk '{printf "├%-35s┬%-35s┤\n", $1, $2}'
		echo "Name Namespace" | awk '{printf "│%-35s│%-35s│\n", $1, $2}'
		echo "$divider $divider" | awk '{printf "├%-35s┼%-35s┤\n", $1, $2}'
		echo "$workloads" | awk '{printf "│%-35s│%-35s│\n", $1, $2}'
		echo "$divider $divider" | awk '{printf "└%-35s┴%-35s┘\n\n", $1, $2}'
	fi
}

# Deployments
d=$(kubectl get deployments --all-namespaces -o json | jq -c '.items[] | select(.spec.template.spec.serviceAccountName==null) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable d "Deployments"


# ReplicaSets
rs=$(kubectl get rs --all-namespaces -o json | jq '.items[] | select((.spec.template.spec.serviceAccountName==null) and (.metadata.ownerReferences==null)) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable rs "ReplicaSets"

# ReplicationController
rc=$(kubectl get rc --all-namespaces -o json | jq '.items[] | select(.spec.template.spec.serviceAccountName==null) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable rc "ReplicationControllers"

# StatefulSets
ss=$(kubectl get statefulsets.app --all-namespaces -o json | jq '.items[] | select(.spec.template.spec.serviceAccountName==null) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable ss "StatefulSets"

# DaemonSets
ds=$(kubectl get ds --all-namespaces -o json | jq '.items[] | select(.spec.template.spec.serviceAccountName==null) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable ds "DaemonSets"

# CronJobs
cj=$(kubectl get cj --all-namespaces -o json | jq '.items[] | select(.spec.jobTemplate.spec.template.spec.serviceAccountName==null) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable cj "CronJobs"

# Jobs
jobs=$(kubectl get jobs.batch --all-namespaces -o json | jq '.items[] | select((.spec.template.spec.serviceAccountName==null) and (.metadata.ownerReferences==null)) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable jobs "Jobs"

# Pods
pods=$(kubectl get pods --all-namespaces -o json | jq '.items[] | select((.spec.serviceAccountName?=="default") and (.metadata.ownerReferences==null)) | "\(.metadata.name) \(.metadata.namespace)"' | cut -d'"' -f2)
printTable pods "Pods"