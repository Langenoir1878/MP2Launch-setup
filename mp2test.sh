# test the creation of topic
# YZln1878
# Nov 19, 2015

#aws sns create-topic --name mp2

# returned ARN: arn:aws:sns:us-east-1:186069030643:mp2
# 1. execute the cleanup.sh
#./cleanup.sh

# 2. declare an array in bash

declare -a instanceARR

# 3. mapfile (updated Nov 4, 2015)
mapfile -t instanceARR < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --security-group-ids $4 --subnet-id $5 --key-name $6  --associate-public-ip-address --iam-instance-profile Name=$7 --user-data file://../MP2Environment-setup/install-webserver.sh --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g" --debug)

echo ${instanceARR[@]}

# 4. wait cli 
aws ec2 wait instance-running --instance-ids ${instanceARR[@]}

echo "instances are running."

# 5. create ELB (updated 11/02/2015, Nov 4, 2015. dif *** ???security-group representations for ec2 and elb?)
ELBURL=(`aws elb create-load-balancer --load-balancer-name SIMMON-THE-CAT --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --security-groups $4 --subnets $5 --output=text`) 
echo $ELBURL



# 5.5 (Nov 7, 2015 cookie stickyness session)
aws elb create-lb-cookie-stickiness-policy --load-balancer-name SIMMON-THE-CAT --policy-name SIMMON-COOKIE-POLICY --cookie-expiration-period 360
aws elb set-load-balancer-policies-of-listener --load-balancer-name SIMMON-THE-CAT --load-balancer-port 443 --policy-names SIMMON-COOKIE-POLICY


# 6. register instances with ELB (updated 11/02/2015)
#aws elb register-instances-with-load-balancer --load-balancer-name SIMMON-THE-CAT --instances ${instanceARR[@]}

# 7. ELB health-check configuration (updated Nov 4, 2015)
aws elb configure-health-check --load-balancer-name SIMMON-THE-CAT --health-check Target=HTTP:80/index.html,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

# wait additional 1 min
#echo -e "\nOpening the ELB in 1 minute in web browser"
#for i in {0..60}; do echo -ne '.'; sleep 1; done


# 8. launch configuration (updated Nov 4, 2015)
echo -e "\nCreating launch configuration: SIMMON-CONFIG-LAUNCH"
aws autoscaling create-launch-configuration --launch-configuration-name SIMMON-CONFIG-LAUNCH --image-id $1 --instance-type $3 --security-groups $4 --key-name $6 --user-data file://../Environment-setup/install-webserver.sh --iam-instance-profile $7 --debug

# 9. auto-scaling (updated Nov 4, 2015)
echo -e "\nCreating the auto scaling group"
aws autoscaling create-auto-scaling-group --auto-scaling-group-name SIMMON-AUTO-SCALE --launch-configuration-name SIMMON-CONFIG-LAUNCH --load-balancer-name SIMMON-THE-CAT --health-check-type ELB --min-size 1 --max-size 3 --desired-capacity 2 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier $5

# secure the count of total instances
# ref: http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_PutScalingPolicy.html
aws autoscaling put-scaling-policy --auto-scaling-group-name SIMMON-AUTO-SCALE --policy-name SIMMON-SCALE-POLICY --scaling-adjustment 1 --adjustment-type ExactCapacity



