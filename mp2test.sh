# test the creation of topic
# YZln1878
# Nov 19, 2015

ARN=$(aws sns create-topic --name mp2)

# returned ARN: arn:aws:sns:us-east-1:186069030643:mp2

# note: subscribed to email: yzhan214@hawk.iit.edu

# Subscription confirmed!

# You have subscribed yzhan214@hawk.iit.edu to the topic:mp2.

# Your subscription's id is: 
# arn:aws:sns:us-east-1:186069030643:mp2:aef1424e-59c6-449f-801b-d0ad1a12ff48


aws sns subscribe --topic-arn $Arn --protocol email --notification-endpoint yzhan214@hawk.iit.edu

aws sns set-topic-attributes --topic-arn $Arn --attribute-name mp2-attribute --attribute-value mp2

aws sns publish --topic-arn $Arn --message "testing sns service"

# to do: 


 
