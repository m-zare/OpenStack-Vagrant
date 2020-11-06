default['openstack']['network']['tun_network_bridge_interface'] = 'lo'
default['openstack']['network']['provider_network_interface'] = 'lo'

default['sample']['network']['dns'] = '1.1.1.1'

default['sample']['network']['provider']['subnet'] = '192.168.57.0/24'
default['sample']['network']['provider']['gateway'] = '192.168.57.2'
default['sample']['network']['provider']['start'] = '192.168.57.5'
default['sample']['network']['provider']['end'] = '192.168.57.25'

default['sample']['network']['selfservice']['subnet'] = '172.16.0.0/24'
default['sample']['network']['selfservice']['gateway'] = '172.16.0.1'
default['sample']['network']['selfservice']['start'] = '172.16.0.5'
default['sample']['network']['selfservice']['end'] = '172.16.0.25'
