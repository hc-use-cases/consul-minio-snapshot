#!/usr/bin/env bash

# we want the scrip to be verbose
set -x

# install packages if not installed
which curl wget unzip jq &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq
}

# get current version of consul that is not beta/alpha
CONSULVER=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

# check if consul is installed
# if not, download and configure service
which consul &>/dev/null || {
  pushd /var/tmp
  echo Installing consul ${CONSULVER}
  wget https://releases.hashicorp.com/consul/${CONSULVER}/consul_${CONSULVER}_linux_amd64.zip
  unzip consul_${CONSULVER}_linux_amd64.zip
  chown root:root consul
  mv consul /usr/local/bin
  consul -autocomplete-install
  complete -C /usr/local/bin/consul consul
  
  # create consul user
  useradd --system --home /opt/consul --shell /bin/false consul
  
  # consul data directory
  [ -d /opt/consul ] || {
    mkdir --parents /opt/consul
    chown --recursive consul:consul /opt/consul
  }
  
  # copy consul configuration 
  mkdir --parents /etc/consul.d
  cp /vagrant/conf/consul_client.hcl /etc/consul.d/consul.hcl
  chown --recursive consul:consul /etc/consul.d
  chmod 640 /etc/consul.d/consul.hcl
  
  # copy service definition
  cp /vagrant/conf/consul_client.service /etc/systemd/system/consul.service
    
  # enable and start service
  systemctl enable consul
  systemctl start consul
  systemctl status consul
  
}
