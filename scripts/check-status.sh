#!/bin/bash

# Checks status of an EMR cluster
# Usage: check-status.sh <cluster_id>

# Check if cluster ID was provided
if [ -z "$1" ]; then
    echo "Error: No cluster ID provided. Please run the script again with a cluster ID."
    exit 1
fi

cluster_id=$1

# Cluster IdleTimeout value in seconds; see --auto-termination-policy
IdleTimeout=7200

# Run the AWS CLI command to get the cluster status
status=$(aws emr describe-cluster --profile midev --cluster-id $cluster_id | jq -r '.Cluster.Status.State')
dns=$(aws emr describe-cluster --profile midev --cluster-id $cluster_id | jq -r '.Cluster.MasterPublicDnsName')
created=$(aws emr describe-cluster --profile midev --cluster-id $cluster_id | jq -r '.Cluster.Status.Timeline.CreationDateTime')

# Calculate the auto-termination time
CreationTimestamp=$(date --utc --date="$created" +%s)
AutoTerminationTimestamp=$((CreationTimestamp + IdleTimeout))
CurrentTimestamp=$(date --utc +%s)
RemainingSeconds=$((AutoTerminationTimestamp - CurrentTimestamp))

# Print the status
echo "The status of the cluster $cluster_id is: $status"
echo "DNS: $dns"
echo "Auto-termination in $RemainingSeconds seconds"
