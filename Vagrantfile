# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  (1..3).each do |i|
    config.vm.define vm_name="consul#{i}" do |node|
      node.vm.box = "apopa/bionic64"
      node.vm.hostname = vm_name
      node.vm.network "public_network", ip: "192.168.178.#{30+i}", bridge: "en7: Dell Universal Dock D6000"
      node.vm.provision "shell", path: "scripts/consul_server.sh"
    end
  end

  config.vm.define vm_name="minio" do |node|
    node.vm.box = "apopa/bionic64"
    node.vm.hostname = vm_name
    node.vm.provision "shell", path: "scripts/minio.sh"
    node.vm.network "public_network", ip: "192.168.178.65", bridge: "en7: Dell Universal Dock D6000"
  end

end

