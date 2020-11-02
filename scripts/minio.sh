#!/usr/bin/env bash

set -x

which minio &>/dev/null || {
  wget https://dl.min.io/server/minio/release/linux-amd64/minio
  chmod +x minio
  mv minio /usr/local/bin

  wget https://dl.min.io/client/mc/release/linux-amd64/mc
  chmod +x mc
  mv mc /usr/local/bin

  mkdir /data
  chown -R vagrant /data && sudo chmod u+rxw /data

  cp /vagrant/conf/minio /etc/default/minio

  cp /vagrant/conf/minio.service /etc/systemd/system/minio.service
  systemctl enable minio
  systemctl start minio
  systemctl status minio

  mc config host add minio http://192.168.178.65.xip.io:9000 minioadmin minioadmin
  mc mb minio/consul-snapshot
  mc admin policy add minio user /vagrant/policy/s3-snapshot.json
}