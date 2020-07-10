# terraform show -json | jq '.values.root_module.resources[] | select(.address | contains("random_password.bigippassword"))  | .values.result' > inspec/bigip-ready/files/password.json
# terraform show -json | jq '.values.root_module.resources[] | select(.address | contains("azurerm_public_ip.management_public_ip"))  | .values.ip_address ' > inspec/bigip-ready/files/mgmtips.json
# inspec exec inspec/bigip-ready


# extract the BIG-IP addresses from the Terraform output
export BIGIP_IPS=`terraform output --json | jq -cr '.bigip_mgmt_public_ips.value[]'`
export BIGIP_USER=admin
# extract the BIG-IP password from the Terraform state
export BIGIP_PASSWORD=`terraform show -json | jq .values.root_module.resources[] | jq -r 'select(.address | contains("random_password")).values.result'`
export DO_VERSION=1.11.1
export AS3_VERSION=3.13.2
export TS_VERSION=1.10.0
# call the Automation Toolchain test profile
for ip in $BIGIP_IPS; do 
    inspec exec bigip-ready --reporter cli --show-progress --input bigip_address=$ip bigip_port=443 user=$BIGIP_USER password=$BIGIP_PASSWORD do_version=$DO_VERSION as3_version=$AS3_VERSION ts_version=$TS_VERSION
done