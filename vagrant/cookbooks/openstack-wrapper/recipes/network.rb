#
# Cookbook:: openstack-wrapper
# Recipe:: network
#
# Copyright:: 2020, The Authors, All Rights Reserved.

class ::Chef::Recipe
  include ::Openstack
end

tun_interface = node['openstack']['network']['tun_network_bridge_interface']
provider_interface = node['openstack']['network']['provider_network_interface']

node.override['openstack']['network']['plugins']['openvswitch']['conf']['ovs']['local_ip'] = address_for(tun_interface)

execute 'create provider network bridge' do
  command 'ovs-vsctl --may-exist add-br br-provider'
end

execute 'create provider network bridge port' do
  command "ovs-vsctl --may-exist add-port br-provider #{provider_interface}"
end

platform_options = node['openstack']['network']['platform']
service 'neutron-metadata-agent' do
  service_name platform_options['neutron_metadata_agent_service']
  supports status: true, restart: true
  action [:disable, :stop]
end
