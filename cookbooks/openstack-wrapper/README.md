# openstack-wrapper

## Attributes

`default.rb` contains values for `sample_network` recipe.
`multinode.rb` values for OpenStack Cluster deployment.

## Deploy an OpenStack Cluster

To deploy `controller`:

- Runlist: openstack-wrapper::multinode_controller
- Environment: multinode_controller

`Compute`:

- Runlist: openstack-wrapper::multinode_compute
- Environment: multinode_compute

Cluster nodes need to have 2 physical interfaces, one used for traffic and overlay traffic, the other for provider network.
The provider interface needs to be `up` without any IP set.
