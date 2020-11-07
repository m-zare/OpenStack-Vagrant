# -*- mode: ruby -*-
# vi: set ft=ruby :

$chef_install = <<SCRIPT
if [[ -e /vagrant/pkg/chef.deb ]]; then
  dpkg -i /vagrant/pkg/chef.deb
fi
SCRIPT

$script = <<SCRIPT
NODE_IP=$(ip route | grep default | egrep -o [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ | tail -n 1)
if [[ -n $NODE_IP ]]; then
  sed -i s/192\.168\.50\.243/$NODE_IP/g /vagrant/cookbooks/openstack-wrapper/attributes/multinode.rb
  sed -i s/192\.168\.50\.243/$NODE_IP/g /vagrant/chef/environments/multinode_controller.json
  sed -i s/192\.168\.50\.243/$NODE_IP/g /vagrant/chef/environments/multinode_compute.json
fi
SCRIPT

#enp0s8 = Network adapter connected to the Internet (external)
#enp0s9 = Network adapter connected to a computer in the same subnet (internal)
$router = <<SCRIPT
apt update

sysctl net.ipv4.ip_forward=1
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt install -y iptables-persistent

iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
iptables -A FORWARD -i enp0s8 -o enp0s9 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i enp0s9 -o enp0s8 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

cat > /etc/init.d/remove_def_route.sh << EOF
ip route del $(ip route | grep default | grep 10.0)
EOF

chmod +x /etc/init.d/remove_def_route.sh
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box_check_update = false
  config.vm.box = "ubuntu/focal64"

######################################################################
  config.vm.define "controller" do |node|
    node.vm.provider "virtualbox" do |v|
      v.memory = 6144
      v.cpus = 2
    end
    node.vm.hostname = "controller"
    node.vm.network "public_network",
      type: "dhcp"
    node.vm.network "private_network",
      ip: "192.168.57.3"

    # install chef
    node.vm.provision "shell",
      inline: $chef_install

    # delete default gw on enp0s3
    node.vm.provision "shell",
      run: "always",
      inline: "ip route del $(ip route | grep default | grep 10.0)"

    node.vm.provision "shell",
      run: "always",
      inline: "ip addr flush enp0s9"

    node.vm.provision "shell",
      inline: $script

    node.vm.provision "chef_zero" do |chef|
      chef.custom_config_path = "chef/CustomConfiguration.chef"
      chef.nodes_path = "chef/nodes"
      chef.environments_path = "chef/environments"
      chef.environment = "multinode_controller"
      chef.cookbooks_path = ["cookbooks","chef/third-party-cookbooks"]
      chef.add_recipe "openstack-wrapper::multinode_controller"
    end
  end

######################################################################
  config.vm.define "compute" do |node|
    node.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
    node.vm.hostname = "compute"
    node.vm.network "public_network",
      type: "dhcp"
    node.vm.network "private_network",
      ip: "192.168.57.4"

    # install chef
    node.vm.provision "shell",
      inline: $chef_install

    # delete default gw on enp0s3
    node.vm.provision "shell",
      run: "always",
      inline: "ip route del $(ip route | grep default | grep 10.0)"

    node.vm.provision "shell",
      run: "always",
      inline: "ip addr flush enp0s9"
    
    # add controller to /etc/hosts
    node.vm.provision "shell",
      inline: "echo $(head -n 1 /vagrant/cookbooks/openstack-wrapper/attributes/multinode.rb |  egrep -o [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) controller >> /etc/hosts"

    node.vm.provision "chef_zero" do |chef|
      chef.custom_config_path = "chef/CustomConfiguration.chef"
      chef.nodes_path = "chef/nodes"
      chef.environments_path = "chef/environments"
      chef.environment = "multinode_compute"
      chef.cookbooks_path = ["cookbooks","chef/third-party-cookbooks"]
      chef.add_recipe "openstack-wrapper::multinode_compute"
    end

    # revert environment updates
    node.vm.provision "shell",
      inline: "cp /vagrant/chef/environments/multinode_controller.json.orig /vagrant/chef/environments/multinode_controller.json && cp /vagrant/chef/environments/multinode_compute.json.orig /vagrant/chef/environments/multinode_compute.json && cp /vagrant/cookbooks/openstack-wrapper/attributes/multinode.rb.orig /vagrant/cookbooks/openstack-wrapper/attributes/multinode.rb"
  end

######################################################################
  config.vm.define "router" do |node|
    node.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    node.vm.hostname = "router"
    node.vm.network "public_network",
      type: "dhcp"
    node.vm.network "private_network",
      ip: "192.168.57.2"

    # delete default gw on enp0s3
    node.vm.provision "shell",
      run: "always",
      inline: "ip route del $(ip route | grep default | grep 10.0)"

    node.vm.provision "shell",
      inline: $router
  end
end
