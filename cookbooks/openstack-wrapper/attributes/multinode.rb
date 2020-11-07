default['controller']['ip'] = '192.168.100.25'
default['controller']['hostname'] = 'controller'
default['controller']['bridge_interface'] = 'enp0s8'
default['controller']['provider_interface'] = 'enp0s9'

default['compute']['bridge_interface'] = 'enp0s8'
default['compute']['provider_interface'] = 'enp0s9'

#################################################
############# Dedault configuration #############
#################################################
force_override['openstack']['is_release'] = true

force_override['openstack']['apt']['update_apt_cache'] = true

force_override['openstack']['telemetry']['conf']['DEFAULT']['meter_dispatchers'] = 'database'

force_override['openstack']['integration-test']['conf']['service_available']['ceilometer'] = false
force_override['openstack']['integration-test']['conf']['service_available']['heat'] = false
force_override['openstack']['integration-test']['conf']['service_available']['horizon'] = false

force_override['openstack']['endpoints']['db']['host'] = node['controller']['hostname']
force_override['openstack']['endpoints']['mq']['host'] = node['controller']['hostname']

%w(bare_metal identity network image_api block-storage compute-api compute-metadata-api compute-novnc 
  orchestration-api orchestration-api-cfn placement-api).each do |service|
  force_override['openstack']['endpoints']['internal'][service]['host'] = node['controller']['hostname']
  force_override['openstack']['endpoints']['public'][service]['host'] = node['controller']['hostname']
end

force_override['openstack']['bind_service']['db']['host'] = '0.0.0.0'
force_override['openstack']['bind_service']['mq']['host'] = '0.0.0.0'
force_override['openstack']['bind_service']['public']['identity']['host'] = '0.0.0.0'
force_override['openstack']['bind_service']['internal']['identity']['host'] = '0.0.0.0'

%w(bare_metal network image_api block-storage compute-api compute-metadata-api compute-novnc orchestration-api orchestration-api-cfn placement-api).each do |service|
  force_override['openstack']['bind_service']['all'][service]['host'] = '0.0.0.0'
end

force_override['openstack']['dashboard']['server_hostname'] = node['controller']['hostname']

force_override['openstack']['memcached_servers'] = ["#{node['controller']['ip']}:11211"]

force_override['openstack']['network']['conf']['transport_url']['rabbit_host'] = node['controller']['ip']

force_override['openstack']['image']['image_upload'] = true

force_override['openstack']['compute']['conf']['libvirt']['cpu_type'] = 'none'
force_override['openstack']['compute']['conf']['libvirt']['virt_type'] = 'qemu'
force_override['openstack']['compute']['conf']['transport_url']['rabbit_host'] = node['controller']['ip']
#################################################
########### End Dedault configuration ###########
#################################################

force_override['openstack']['use_databags'] = false
force_override['openstack']['databag_type'] = 'standard'

force_override['openstack']['compute']['libvirt']['libvirtd_opts'] = ''
force_override['openstack']['compute']['platform']['libvirt_packages'] = 'python3-guestfs'

force_override['openstack']['release'] = 'ussri'
force_override['openstack']['apt']['live_updates_enabled'] = false

if node['hostname'] =~ /controller/
  force_override['openstack']['network']['tun_network_bridge_interface'] = node['controller']['bridge_interface']
  force_override['openstack']['network']['provider_network_interface'] = node['controller']['provider_interface']
  force_override['openstack']['network']['conf']['DEFAULT']['service_plugins'] = 'router'
  force_override['openstack']['network']['conf']['DEFAULT']['allow_overlapping_ips'] = 'true'
elsif node['hostname'] =~ /compute/
  force_override['openstack']['network']['tun_network_bridge_interface'] = node['compute']['bridge_interface']
  force_override['openstack']['network']['provider_network_interface'] = node['compute']['provider_interface']
end
force_override['openstack']['network']['conf']['DEFAULT']['core_plugin'] = 'ml2'
force_override['openstack']['network']['conf']['DEFAULT']['auth_strategy'] = 'keystone'

if node['hostname'] =~ /controller/
  force_override['openstack']['network']['plugins']['ml2']['path'] = '/etc/neutron/plugins/ml2'
  force_override['openstack']['network']['plugins']['ml2']['filename'] = 'ml2_conf.ini'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2']['type_drivers'] = 'flat,vlan,vxlan'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2']['tenant_network_types'] = 'vxlan'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2']['extension_drivers'] = 'port_security'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2']['mechanism_drivers'] = 'openvswitch,l2population'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2_type_flat']['flat_networks'] = 'provider'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2_type_vlan']['network_vlan_ranges'] = 'provider'
  force_override['openstack']['network']['plugins']['ml2']['conf']['ml2_type_vxlan']['vni_ranges'] = '1:1000'
  force_override['openstack']['network']['plugins']['ml2']['conf']['securitygroup']['enable_ipset'] = 'true'
end

force_override['openstack']['network']['plugins']['openvswitch']['path'] = '/etc/neutron/plugins/ml2'
force_override['openstack']['network']['plugins']['openvswitch']['filename'] = 'openvswitch_agent.ini'
force_override['openstack']['network']['plugins']['openvswitch']['conf']['ovs']['bridge_mappings'] = 'provider:br-provider'
force_override['openstack']['network']['plugins']['openvswitch']['conf']['agent']['tunnel_types'] = 'vxlan'
force_override['openstack']['network']['plugins']['openvswitch']['conf']['agent']['l2_population'] = 'true'
force_override['openstack']['network']['plugins']['openvswitch']['conf']['securitygroup']['firewall_driver'] = 'iptables_hybrid'

if node['hostname'] =~ /controller/
  force_override['openstack']['network_l3']['conf']['DEFAULT']['interface_driver'] = 'openvswitch'
elsif node['hostname'] =~ /compute/
  force_override['openstack']['network_dhcp']['conf']['DEFAULT']['interface_driver'] = 'openvswitch'
  force_override['openstack']['network_metadata']['conf']['DEFAULT']['nova_metadata_ip'] = node['controller']['hostname']
end

admin_user = node['openstack']['identity']['admin_user']
user = node['openstack']['mq']['user']
stack_domain_admin = node['openstack']['orchestration']['conf']['DEFAULT']['stack_domain_admin']
user_key = node['openstack']['db']['root_user_key']

default['openstack']['common']['services'].each do |_, project|
  force_override['openstack']['secret'][project]['db'] = 'P@ssw0rd'
end
force_override['openstack']['secret'][user_key]['db'] = 'P@ssw0rd'
%w(telemetry telemetry_metric aodh).each do |telemetry_service|
  force_override['openstack']['secret']["openstack-#{telemetry_service}"]['service'] = 'P@ssw0rd'
end
force_override['openstack']['secret'][admin_user]['user'] = 'P@ssw0rd'
force_override['openstack']['secret'][user]['user'] = 'P@ssw0rd'
force_override['openstack']['secret'][stack_domain_admin]['user'] = 'P@ssw0rd'
force_override['openstack']['secret'][node['openstack']['db']['root_user_key']]['db'] = 'P@ssw0rd'
force_override['openstack']['secret'][default['openstack']['network_metadata']['secret_name']]['token'] = 'P@ssw0rd'
force_override['openstack']['secret']['aodh']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['ceilometer']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['cinder']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['designate']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['glance']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['gnocchi']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['heat']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['horizon']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['ironic']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['keystone']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['neutron']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['nova']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['nova_api']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['nova_cell0']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['placement']['db'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-aodh']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-bare-metal']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-block-storage']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-compute']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-dns']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-image']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-network']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-orchestration']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-placement']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-telemetry']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['openstack-telemetry_metric']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['rabbit_cookie']['service'] = 'P@ssw0rd'
force_override['openstack']['secret']['designate_rndc']['token'] = 'P@ssw0rd'
force_override['openstack']['secret']['neutron_metadata_secret']['token'] = 'P@ssw0rd'
force_override['openstack']['secret']['orchestration_auth_encryption_key']['token'] = 'P@ssw0rd'

force_override['openstack']['identity']['fernet']['0'] = "HVsoAu3kQvckSGHq5oS2vVPl_PW2rQoFXCzcYygCpkQ="
force_override['openstack']['identity']['fernet']['1'] = "7oYYd6jpRnnXBX-N1W1Pl_xh5mKDjyjofILCH4Dlh0o="
force_override['openstack']['identity']['fernet']['keys'] = []
force_override['openstack']['identity']['credential']['keys'] = []

force_override['openstack']['dashboard']['ssl']['use_data_bag'] = false
force_override['openstack']['dashboard']['ssl']['content']['cert'] = "-----BEGIN CERTIFICATE-----\nMIICxjCCAa6gAwIBAgIJAMnb6oIuRz+nMA0GCSqGSIb3DQEBBQUAMBUxEzARBgNV\nBAMTCmNvbnRyb2xsZXIwHhcNMjAxMTA3MTQzMTEwWhcNMzAxMTA1MTQzMTEwWjAV\nMRMwEQYDVQQDEwpjb250cm9sbGVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB\nCgKCAQEAtxZ2G74683cWxVpKie3lFO8gskOt9FI9Nx9+ZKbjf7eJqOiRZT0E0n9U\nJoscEClbJAsLc5rzKXL4AI2Kv52DX1R1a+zYYsnwSTcBB5Dh2y/qK8eBg/QG9yzE\nmwCVfK2w3ylNpYbDHi601leMUZOAymILT07LXJIeMwmdzuq6Z4EHZVvFq+VLHWE9\njU0D9rKieyybZLpdR+5n3+nNccF0zQH25sQPEOcy/tRvoYSha128+keO1fjgL1ak\nZNknpyqCGP5kEsuUKShWUvD7/ga/qzfzU2pOm5HRXKBzZl3s3AwKybnd1oT91Z+6\n8Q5r57VFBFd1Nvw/cnjBkC0ItA7HNwIDAQABoxkwFzAVBgNVHREEDjAMggpjb250\ncm9sbGVyMA0GCSqGSIb3DQEBBQUAA4IBAQACzIyAj1Q1xGsel8fzqZYyNKQPWRUg\nbdQQo7RuxckW2AG3sCe8slpvDihtUBT+04sh0GNtiuEvTsPEVSWyu4kGY4Adff/E\n6Iawvc2eftF9wZOcynUY/FAbx6mAOPOheSQFy8OkZNotaQZ6BYMDkvnzoYbAivjP\nS1kZ+9snHWV51hXMkzPTXaWDtzEwTrMPU2cbllmeYfLxolh7qKl+1OM+2j2dkGCR\nbi5TwNasWZGR0FLNp7GvNPhfd2h6NNce5VHo7UGST4lbO8tNUYE/lnEX5SbwZ2ql\ntkg0Mar5zDlG8CmtImW6sHPEfXHWQH8K8mDFbzsbJ3mC1Q5RjdOa74FO\n-----END CERTIFICATE-----"
force_override['openstack']['dashboard']['ssl']['content']['key'] = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAtxZ2G74683cWxVpKie3lFO8gskOt9FI9Nx9+ZKbjf7eJqOiR\nZT0E0n9UJoscEClbJAsLc5rzKXL4AI2Kv52DX1R1a+zYYsnwSTcBB5Dh2y/qK8eB\ng/QG9yzEmwCVfK2w3ylNpYbDHi601leMUZOAymILT07LXJIeMwmdzuq6Z4EHZVvF\nq+VLHWE9jU0D9rKieyybZLpdR+5n3+nNccF0zQH25sQPEOcy/tRvoYSha128+keO\n1fjgL1akZNknpyqCGP5kEsuUKShWUvD7/ga/qzfzU2pOm5HRXKBzZl3s3AwKybnd\n1oT91Z+68Q5r57VFBFd1Nvw/cnjBkC0ItA7HNwIDAQABAoIBAQCbvlKoFPFGzAYl\nyUHhBOo7HZOdsO7YB+Ek8/hrnH+n1DQY6AVOrlJc0Y1+4BT2NofeKDsMk0HH/5Gx\nvrXJfC8Vt93O+gG0P33UeiK5EejesGqt5R9qZPpL5twz0pJXJdVwcE0pwnJWSXrx\nXjXx6tzCzBY815UsYOuplMOWEZyRkAMhj+CF6bMuxRXNBM9Ym3yMQ+AuIfU9+pwU\nonfoWS5YBN4TZ7QJxOXeGvDhru8bT96rWts6nssi9xlT3hbY4jMBJBuy17Dj09OR\nwwQHwidsgKt7GtBPwrH7g6Yzn5fe//i9ntY4hqvSA+rV7SBvrEaP+uipR3N59PTZ\ncesN2b5pAoGBAOSDYQWPfUqGOIO/cPnzrp3pCWdYnnqhpivJ6xSbAqN9X51SDdRs\nWdSTazQLy7AeTCSKb2Fl/akNINIkbfwnloEqDMWZ5NdmrMe4AeeDlKWLlwj/D58g\nWc1wpmhRrZnJhCsUdXOwin92Qo/W0RG/LMhaOkqI/d34TIdZPA9HC3B1AoGBAM0c\nSxw37gPd8/AhuacHcXMIZfEJOqZs9Mio9uGHjRjENLvNgb/h5ID/VZoam1yf2Cwl\nph80YH0aa826iWHO5U5C4qB5gEbr9q0coMJ2IN0ruApxRfuXXPtwexuOQjODa+Vb\nrda4XiEmy9Fxt7a9IJnQPBFosfPU+SM4d4geeON7AoGBANc1J/WNqmi6OZVSgbrV\nFVmgc/vBiRdjD9Vjh6LTTcvdMmQ+N8ob9QnvgGH2zfDix8EOI1FuNVO1inh+WJrG\nSccBbB/ZDJ0UFJrPH/QChsbVzPtrAzJQzGJfuki6y6zvDStpTCgVVoouPQesPx/g\nlPNnjkhN9hDLXH+HubmFpi9VAoGAcG/wJLnsOiZz0NFMCmokIOEbsPRUOGNGFLG7\nFIrQKCF2nvTbCar1LlnKPT4UqMPfJuREmpqFwk63hgGZygo23Z4AyeORFE/J27/z\nyGYlQdjzfJX3vSGOkS9p7QMg+0gx33tQYoKS5y1zUY87HGu08VybcRepZXb8U/hi\nXjYGIv0CgYB2yKecXlkbiR/YTjnNN8SZdO3mxkBef42PbPgimGJpsnThjEAf2IGp\nEYdG9OjceTMK6Gh2TawP+xi6MGUTUwp63hcE/Pwf+TiPObB1AiWCl2mJ1Rq9p227\nRBKwUeD0z4gtlnk+G6M7El6HO4MObTjnnl0q/0btx8Tt2yujf01u1g==\n-----END RSA PRIVATE KEY-----"
