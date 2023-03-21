#!bin/bash

# to set default if the first argument is not passed it will set using second argument passed

function set_defaults(){
value=$1
if [[ -z $value ]]; then
value=$2
fi
echo $value
}
# to get the instance id which are available and 
function get_instances_by_tags(){
tag_name=$(set_defaults $1 Env)
tag_value=$(set_defaults $2 QA)
instanceids=$(aws ec2 describe-instances --filters "Name=tag:${tag_name},Values=${tag_value}" --query "Reservations[].Instances[].InstanceId" --output text)
echo $instanceids
}
target_instance_type=$(set_defaults $3 t2.nano)
instanceids=$(get_instances_by_tags $1 $2)
for instanceid in $instanceids
do 
aws ec2 stop-instances --instance-ids ${instanceids}
echo "resizing the instance id ${instanceid}"
aws ec2 modify-instance-attribute --instance-id ${instanceid} --instance-type ${target_instance_type}
done
