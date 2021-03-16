#!/bin/bash
VCENTER_NAME=""
VCENTER_USER=""
VCENTER_PASSWORD=""
STANDARD_2016_KEY=""
ENTERPRISE_2016_KEY=""
STANDARD_2019_KEY=""
ENTERPRISE_2019_KEY=""

sed -i "s/###VCENTER_NAME###/${VCENTER_NAME}/" credentials.json
sed -i "s/###VCENTER_USER###/${VCENTER_USER}/" credentials.json
sed -i "s/###VCENTER_PASSWORD###/${VCENTER_PASSWORD}/" credentials.json

find autounattend/2016 -type f -exec sed -i "s/###STANDARD_KEY###/${STANDARD_2016_KEY}/g" {} \;
find autounattend/2016 -type f -exec sed -i "s/###DATACENTER_KEY###/${ENTERPRISE_2016_KEY}/g" {} \;
find autounattend/2019 -type f -exec sed -i "s/###STANDARD_KEY###/${STANDARD_2019_KEY}/g" {} \;
find autounattend/2019 -type f -exec sed -i "s/###DATACENTER_KEY###/${ENTERPRISE_2019_KEY}/g" {} \;

