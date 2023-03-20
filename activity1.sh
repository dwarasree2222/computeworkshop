#!bin/bash

instanceid=$(aws ec2 describe-instances --filters "Name=tag:Env,Values=QA,DEV" --query "Reservations[].Instances[].InstanceId
" "Name=instance-state-name,Values=running" --output text)
echo "${instanceid}"
if [[ -n "${instanceid}" ]]
then
echo "stopping the instances ${instanceid}"
aws ec2 stop-instances --instance-ids ${instanceid}
else
echo "does not have any instances matching with tag Env=QA"
fi