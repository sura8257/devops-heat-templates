#!/bin/bash

LOGFILE="/var/log/cloud-init-chef-bootstrap.setup.$$"
CHEFRUNLOGFILE="/var/log/cloud-init-chef-bootstrap.first-run.$$"
CHEF_CLIENT_VERSION="11.16.4"
RAX_AUTOSCALE_LOG="/var/log/rax-autoscaler.setup.$$"

# Set variables
PYSTRESS_TIME=%pystress_time%
GIT_BRANCH=%git_branch%

# Initial timestamp and debug information
date > $LOGFILE
echo "Starting cloud-init bootstrap" >> $LOGFILE
echo "organization parameter: %organization%" >> $LOGFILE
echo "run_list parameter: %run_list%" >> $LOGFILE

# Install, setup and start cloud monitoring agent
wget http://meta.packages.cloudmonitoring.rackspace.com/centos-7-x86_64/rackspace-cloud-monitoring-meta-stable-1-0.noarch.rpm
rpm -Uvh rackspace-cloud-monitoring-meta-stable-1-0.noarch.rpm
yum update -y
yum install -y rackspace-monitoring-agent 
rackspace-monitoring-agent --setup --username %username% --apikey %api_key%
service rackspace-monitoring-agent start

# Install pip and dependent packages
yum install -y gcc python-devel python-pip git wget >>$RAX_AUTOSCALE_LOG 2>&1 

# Clone rax-autoscaler git repo
git clone -b $GIT_BRANCH https://github.com/rackerlabs/rax-autoscaler.git /root/rax-autoscaler >>$RAX_AUTOSCALE_LOG 2>&1

# Create README.txt
touch  /root/rax-autoscaler/README.txt 

# Setup rax-autoscaler
cd /root/rax-autoscaler && python setup.py develop >>$RAX_AUTOSCALE_LOG 2>&1

# Create credential file
echo "
[rackspace_cloud]
identity_type = keystone
username = %username%
api_key = %api_key%
">/root/.pyrax.cfg

# Download python script to get config form cloud file container
wget http://119.9.25.40/myfiles/public_html/cloudFile.py -O /root/cloudFile.py >>$RAX_AUTOSCALE_LOG 2>&1

# Execute script 
python /root/cloudFile.py >>$RAX_AUTOSCALE_LOG 2>&1

# Create cron job to execute rax-autoscaler
echo "*/1 * * * * root /usr/bin/python /root/rax-autoscaler/raxas/autoscale.py --cluster --config-file /root/config.json >/tmp/autoscale.log 2>&1" >/etc/cron.d/autoscale

# Infer the Chef Server's URL if none was passed
CHEFSERVERURL='%chef_server_url%'
if [ -n $CHEFSERVERURL ]; then
  echo "chef_server_url parameter: not passed" >> $LOGFILE
  CHEFSERVERURL="https://api.opscode.com/organizations/%organization%"
else
  echo "chef_server_url parameter: $CHEFSERVERURL" >> $LOGFILE
  CHEFSERVERURL="%chef_server_url%"
fi

# Store the validation key in /etc/chef/validator.pem
echo "Storing validation key in /etc/chef/validator.pem"
mkdir /etc/chef /var/log/chef &>/dev/null
cat >/etc/chef/validator.pem <<EOF
%validation_key%
EOF

# Cook a minimal client.rb for getting the chef-client registered
echo "Creating a minimal /etc/chef/client.rb" >> $LOGFILE
touch /etc/chef/client.rb
cat >/etc/chef/client.rb <<EOF
  log_level        :info
  log_location     STDOUT
  chef_server_url  "$CHEFSERVERURL"
  validation_key         "/etc/chef/validator.pem"
  validation_client_name "%organization%-validator"
  environment   "%environment%"
EOF

# Cook the first boot file
echo "Creating a minimal /etc/chef/first-boot.json" >> $LOGFILE
touch /etc/chef/first-boot.json
cat >/etc/chef/first-boot.json <<EOF
{"run_list":[%run_list%]}
EOF

# Install chef-client through omnibus (if not already available)
if [ ! -f /usr/bin/chef-client ]; then
  echo "Installing chef using omnibus installer" >> $LOGFILE
  # adjust to install the latest vs. a particular version
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- -v $CHEF_CLIENT_VERSION -- &>$LOGFILE
  echo "Installation of chef complete" >> $LOGFILE
fi

# Kick off the first chef run
echo "Executing the first chef-client run"
if [ -f /usr/bin/chef-client ]; then
  count=1
  rv=1
  while [ $rv -ne 0 ]; do
    /usr/bin/chef-client -j /etc/chef/first-boot.json >> $CHEFRUNLOGFILE
    rv=$?
    let count=count+1
    echo "chef-client execution returned $rv, execution count: $count" >> $LOGFILE
  done
fi

# Restart chef-client service.
service chef-client restart

# Script complete. Log final timestamp
date >> $LOGFILE

if [ $PYSTRESS_TIME -eq 0 ]
then
  echo "No need to install pystress, pystress_time is set to '0'" >>$RAX_AUTOSCALE_LOG
else
  # Install pystress
  pip install pystress >>$RAX_AUTOSCALE_LOG 2>&1

  echo "Stress CPU(s) with 2 processes for %pystress_time% seconds" >>$RAX_AUTOSCALE_LOG
  pystress %pystress_time% 2 & 
fi

date >>$RAX_AUTOSCALE_LOG

exit 0
