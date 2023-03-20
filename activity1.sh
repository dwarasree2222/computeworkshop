#!bin/bash
tag_name=$1
tag_value=$2

instanceid=$(aws ec2 describe-instances --filters "Name=tag:${tag_name},Values=${tag_value}" --query "Reservations[].Instances[].InstanceId
" "Name=instance-state-name,Values=running" --output text)

if [[ -z "${tag_name}" ]]; then
tag_name="Env"
fi
if [[ -z "${tag_value}" ]]; then
tag_value="QA"
fi

echo "${instanceid}"
if [[ -n "${instanceid}" ]];
then
echo "stopping the instances ${instanceid}"
aws ec2 stop-instances --instance-ids ${instanceid}
else
echo "does not have any instances matching with tag ${tag_name}=${tag_value}"
fi