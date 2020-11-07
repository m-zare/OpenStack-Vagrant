default['controller']['ip'] = '192.168.50.243'
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
force_override['openstack']['dashboard']['ssl']['content']['cert'] = "-----BEGIN CERTIFICATE-----\nMIIC5zCCAc+gAwIBAgIJAManL/xvuuP1MA0GCSqGSIb3DQEBBQUAMCAxHjAcBgNV\nBAMTFW9wZW5zdGFjay5kZXJpdi5jbG91ZDAeFw0yMDEwMTEwNzQwNTZaFw0zMDEw\nMDkwNzQwNTZaMCAxHjAcBgNVBAMTFW9wZW5zdGFjay5kZXJpdi5jbG91ZDCCASIw\nDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM85ZFqn7LKVQiXD1oyczJGSL1Zx\nzbKuJ76lzv8TxRixWRv3Y9RLnHo17Le7NAWzVPcECV8SI7Uoo96Wk6Ra9NamJFDe\nqRKRH80jV3cmRQVagDj67YSFcbgcVy0MHlmvd6VwQ7m1rrRibEJIDpoO+riK5HVd\nesPpjiIUCn/Lug60h4WTCByE9LvE8G2lKqW7Sva8W6NIhNT6IPqe3pdXhqlBDJdK\nDHeqA88q6mJsUapdmyptFPQyXyb+Oo1EhsqUksJ1VWV+M2inK5fXEMGMNzdNKCXM\nw7ZQNStAGSeI7jgtV6m3rpRtDcIUZl5ypuSPYzEZ2prTVNFSO3bR0A0KdMkCAwEA\nAaMkMCIwIAYDVR0RBBkwF4IVb3BlbnN0YWNrLmRlcml2LmNsb3VkMA0GCSqGSIb3\nDQEBBQUAA4IBAQAd9kYeYU2MiVPZnjGTEw8daorUbb44tt5o4/hZRnvGrv1iB2bk\n4hSOGjtqz8hpbiSdBFUZeIkKG96xXQOa+op4xX0c4j3dIWk+enoPunY3ihAWgqvo\nqOKsI8PfecROXVLrIYZS855rQWRVFZJlBf2vq0F4J3AYQYMIOFTN4HWM5t6hZsSq\nOslu/7wX38xfC8+SeC1Yl+VfKwM3QnxfhlIsufC6nKsOosO4vjoIANxpz1DfffBz\nCfIwoi6imyhhIq9nRVCfmejfaStI8MqnK4pUG6lbYAducp3SZHDqa1TOVp/j6hlK\nMskJ0zxhCkj7Ve0P1aOWYDsTwzn/88/aGhVp\n-----END CERTIFICATE-----"
force_override['openstack']['dashboard']['ssl']['content']['key'] = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAzzlkWqfsspVCJcPWjJzMkZIvVnHNsq4nvqXO/xPFGLFZG/dj\n1EucejXst7s0BbNU9wQJXxIjtSij3paTpFr01qYkUN6pEpEfzSNXdyZFBVqAOPrt\nhIVxuBxXLQweWa93pXBDubWutGJsQkgOmg76uIrkdV16w+mOIhQKf8u6DrSHhZMI\nHIT0u8TwbaUqpbtK9rxbo0iE1Pog+p7el1eGqUEMl0oMd6oDzyrqYmxRql2bKm0U\n9DJfJv46jUSGypSSwnVVZX4zaKcrl9cQwYw3N00oJczDtlA1K0AZJ4juOC1Xqbeu\nlG0NwhRmXnKm5I9jMRnamtNU0VI7dtHQDQp0yQIDAQABAoIBAACBg101S76j3qV4\n9O0i9NzmHnd3j6kAA9jTTs4QnkqRJEaNNBEwnhEuUIWiT140MeDogZ1ZzfyDPOMu\nOu4Lys07WptX79G7yPgXPf9seH6q2eVJt4q7SKvKZewWO3y8kO42d/PcHbETDHCc\n/Gwj3TjWHfirYcFYsKAkrGHjfXDLvukGdLsERtVz88JkGeK2/kyfJJDbzXyLB+M+\nHFt2Ye4m5nTewBG7yR99IYMwJzHcEHmXNaW7nfIivFoFN3SpcZIej1+UhiadSZHv\nvCh8NrjHbfChm2KU4PGMbmclANqEcOaIfNTEKFFl7LB19CqjWnwC6/Lyp/hjX9Gh\n67qC2oECgYEA6Vj5f6vq46WVYfezu3ObAa6LAYZIisMRoPvUzGlb5gV7z/JRcUX8\nxmWB4qxmqozU4uG0lRa/4bWzgBI5vjObf1DL/0QWfws9sNm66rmbxPA070Q19FkK\nA88lzohSSCyWh9cW+LOLHmH/VN3klXyEdnkz3LJgagJdv8+xHSHiFOsCgYEA41c2\nuUiXGx6HN4L3ZEpR3RkV2hxpBlEUnFuXgtzMmWJxEDY9gNHoq1+nbZnB1xhRyNYG\nhMHTAQnNJhIiBZWItCSm8rTE71fpLy84zBQk6koNeMi2yKmm8+BNkbNdDTZRV900\n7Xjmma+xunxTdtwCuojZQVEUpfAA86RYHwcGwBsCgYEArVzvMI1XW33/t+NB4viG\npv84Qw+zAXTfugyfEqcMIZ7dV6ceHtvyaqurje6r7/XljBJICaP3Nwe5rmLcB5Vr\n53Dtvl6loAmH8cYxeoYfVndnvIOe2kT0jdPusLzS9NA7nfyNEoTBzPbdrf2VAAKc\nnzB4+XSE8P2FDSaO3af4wbUCgYEA1LnrDv0Jx+qNBDicXU/dwlGSzQEAlVSRQK3D\n3EPXfz9KJK1cZ4oDeTiMZlYVt7ud65u5hcgINVSCjjkxdKAzxrz1Ku5TyNIt9GTv\ndKb00/ZvHLJTtvhorJMaglefnplRDDKFMCCNRwnL+IAVaYb9VqZvBFtmQs+NVG5X\nttDQVDkCgYA3VpTL4/FbKG13fAZNg0g38niWeOreCTstPeCVKVdCZQW85L5Xd30l\nYzLaaKpJtG6eshUMn80G1CKRNjiScL3TPA2giC+5uO1bTGhUitI42E4fwKkUqffY\nbf5/vIafBACFZ33e+vhx6OtO4MvL6/HJR2EFXhEbx9LicZVwCkkmBw==\n-----END RSA PRIVATE KEY-----"
