#!/bin/bash
VCENTER_NAME=""
VCENTER_USER=""
VCENTER_PASSWORD=""
2016_STANDARD_KEY=""
2016_ENTERPRISE_KEY=""
2019_STANDARD_KEY=""
2019_ENTERPRISE_KEY=""

sed -i ´s/###VCENTER_NAME###/${VCENTER_NAME}/´ credentials.json
sed -i ´s/###VCENTER_USER###/${VCENTER_USER}/´ credentials.json
sed -i ´s/###VCENTER_PASSWORD###/${VCENTER_PASSWORD}/´ credentials.json

find autounattend/2016 -type f -exec sed -i `` -e 's/###STANDARD_KEY###/${2016_STANDARD_KEY}/g' {} \;
find autounattend/2016 -type f -exec sed -i `` -e 's/###DATACENTER_KEY###/${2016_ENTERPRISE_KEY}/g' {} \;
find autounattend/2019 -type f -exec sed -i `` -e 's/###STANDARD_KEY###/${2019_STANDARD_KEY}/g' {} \;
find autounattend/2019 -type f -exec sed -i `` -e 's/###DATACENTER_KEY###/${2019_ENTERPRISE_KEY}/g' {} \;

