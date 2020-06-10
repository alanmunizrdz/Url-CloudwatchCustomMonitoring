#!/bin/bash

###
#  This script consult all the URL for domains that are contained in the $route,
#  It extract the url from all the Sugarcrm instances in the $route.
#  Get the url without , and '  and check the HTTP code and if it is different from redirection or 200
#  Sends a metrics message to AWS Cloudwatch and metrics to AWS Cloudwatch
#
# IMPORTANT:
# To make this work you need to configure your AWS-CLI with the correct permissions.
# By: Alan Muniz
# #v: 1.0.1
###

#variables
iam=$(pwd)
timestamp=$(date +%s000)
instance_id="#InstanceID"
date=$(date)
route='/route/of/sugar/Instances'


###
# Obtain all the domains 
###
rm $iam/sites.txt
cd $route && cat */config.php  | grep -i "host_name" | grep -v "db_host_name" | awk {'print $3'}  | sed 's/,*$//g' | sed 's/'\''//g' >> $iam/sites.txt


###
# Read line per line and storage it on a array
###
getArray()
{
array=()
  while IFS= read -r line
  do
	   array+=("$line")
   done < "$1"
}
getArray "$iam/sites.txt"


#Check URLs HTTP code one by one 
for url in "${array[@]}"
do
  echo "The website is: $url"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" $url)
    if [ "$STATUS" == "200" ] || [ "$STATUS" == "301" ] || [ "$STATUS" == "302" ]; then
        echo "$url is up, returned $STATUS"
    else
        echo "$url is not up, returned $STATUS"
###
# This will send the metric to metrics Cloudwatch
###
        bash $iam/jsongenerator.sh $instance_id $url $STATUS "$date" $timestamp
        sleep 5        
        aws cloudwatch put-metric-data --metric-name NAME --value 100 --namespace "NAME" --dimensions InstanceId="$instance_id"
	      #aws cloudwatch put-metric-data --namespace "SiteStatus" --metric-data file://$iam/metricsOutput.json        
###
# This sends the message to logstream on Cloudwatch
### 
        sleep 5
        aws logs create-log-stream --log-group-name "/aws/cloudwatch/Logs" --log-stream-name $timestamp
        sleep 5
        aws logs put-log-events --log-group-name "/aws/cloudwatch/Logs" --log-stream-name "$timestamp" --log-events file://$iam/logsoutput.json
    fi
done 

#Example command

#aws cloudwatch put-metric-data --metric-name HTTP-Code --value 100 --namespace "SiteStatus" --dimensions InstanceId=i-02f57105f547a1de1

#aws logs create-log-stream --log-group-name "/aws/cloudwatch/WebsiteStatusMessage" --log-stream-name $timestamp
#aws logs put-log-events --log-group-name "/aws/cloudwatch/WebsiteStatusMessage" --log-stream-name "test123" --log-events file://logsoutput.json 
