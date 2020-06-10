#!/bin/bash

#variables
iam=$(pwd)
instance_id=$1
url=$2
STATUS=$3
date=$4
timestamp=$5
###
# Creating json for metrics
###
        
        rm $iam/metricsOutput.json
        echo "["  >> $iam/metricsOutput.json
        echo " {" >> $iam/metricsOutput.json
        echo "  \"MetricName\": \"SiteStatus\","  >> $iam/metricsOutput.json
        echo "  \"Timestamp\": \"$4\"," >> $iam/metricsOutput.json
        echo "  \"Value\": 100,"  >> $iam/metricsOutput.json
        echo "  \"Unit\": \"Count\""  >> $iam/metricsOutput.json
        echo " }" >> $iam/metricsOutput.json
        echo "]"  >> $iam/metricsOutput.json
        wait
###
# Create json for logs
###
        rm $iam/logsoutput.json
        echo " [ " >> $iam/logsoutput.json
        echo "   { " >> $iam/logsoutput.json
        echo "    \"timestamp\": $5, " >> $iam/logsoutput.json
        echo "    \"message\": \"  "instance_id": "$1",  "site:": "$2",  "status": "DOWN", "status_code": "$3", "Timestamp": "$4" \" " >> $iam/logsoutput.json
        echo "   } " >> $iam/logsoutput.json
        echo " ] " >> $iam/logsoutput.json
        wait 
