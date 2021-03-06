include_recipe 'memcached'
include_recipe 'openstack-common'
include_recipe 'openstack-common::logging'
include_recipe 'openstack-common::sysctl'
include_recipe 'openstack-common::client'
include_recipe 'openstack-common::etcd'
include_recipe 'openstack-ops-database::server'
include_recipe 'openstack-ops-database::openstack-db'
include_recipe 'openstack-ops-messaging::rabbitmq-server'
include_recipe 'openstack-wrapper::fernet_tokens'
include_recipe 'openstack-identity::server-apache'
include_recipe 'openstack-identity::registration'
include_recipe 'openstack-identity::openrc'
include_recipe 'openstack-image::api'
include_recipe 'openstack-image::identity_registration'
include_recipe 'openstack-network'
include_recipe 'openstack-network::openvswitch'
include_recipe 'openstack-wrapper::network'
include_recipe 'openstack-network::plugin_config'
include_recipe 'openstack-network::server'
include_recipe 'openstack-network::ml2_openvswitch'
include_recipe 'openstack-network::openvswitch_agent'
include_recipe 'openstack-network::l3_agent'
include_recipe 'openstack-compute::nova-setup'
include_recipe 'openstack-compute::identity_registration'
include_recipe 'openstack-compute::conductor'
include_recipe 'openstack-compute::api-os-compute'
include_recipe 'openstack-compute::api-metadata'
include_recipe 'openstack-compute::placement_api'
include_recipe 'openstack-compute::scheduler'
include_recipe 'openstack-compute::vncproxy'
include_recipe 'openstack-block-storage::api'
include_recipe 'openstack-block-storage::scheduler'
include_recipe 'openstack-block-storage::volume_driver_lvm'
include_recipe 'openstack-block-storage::volume'
include_recipe 'openstack-block-storage::backup'
include_recipe 'openstack-block-storage::identity_registration'
include_recipe 'openstack-bare-metal::api'
include_recipe 'openstack-bare-metal::conductor'
include_recipe 'openstack-bare-metal::identity_registration'
include_recipe 'openstack-orchestration::engine'
include_recipe 'openstack-orchestration::api'
include_recipe 'openstack-orchestration::api-cfn'
include_recipe 'openstack-orchestration::identity_registration'
include_recipe 'openstack-dns::api'
include_recipe 'openstack-dns::central'
include_recipe 'openstack-dns::sink'
include_recipe 'openstack-dns::identity_registration'
include_recipe 'openstack-image::image_upload'
include_recipe 'openstack-wrapper::ssl_keys'
include_recipe 'openstack-dashboard::horizon'
# include_recipe 'openstack-wrapper::sample_network'
