#!/bin/bash

LOGFILE="/var/log/cloud-init-chef-bootstrap.setup.$$"
CHEFRUNLOGFILE="/var/log/cloud-init-chef-bootstrap.first-run.$$"

# Initial timestamp and debug information
date > $LOGFILE
echo "Starting cloud-init bootstrap" >> $LOGFILE
echo "organization parameter: %organization%" >> $LOGFILE
echo "run_list parameter: %run_list%" >> $LOGFILE

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
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- &>$LOGFILE
  echo "Installation of chef complete" >> $LOGFILE
fi

# Kick off the first chef run
echo "Executing the first chef-client run"
if [ -f /usr/bin/chef-client ]; then
  echo "First Chef client run with empty run list" >> $LOGFILE
  /usr/bin/chef-client >> $CHEFRUNLOGFILE
  
  echo "First Chef client run with first-boot run list" >> $LOGFILE
  /usr/bin/chef-client -j /etc/chef/first-boot.json >> $CHEFRUNLOGFILE
fi

# Script complete. Log final timestamp
date >> $LOGFILE

exit 0
