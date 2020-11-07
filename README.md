# OpenStack-Vagrant

## Requirements

- [Chef Workstation](https://downloads.chef.io/products/workstation)
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or any other cd [provider](https://www.vagrantup.com/docs/providers) supported by vagrant)

## How to

Clone/download this repo.

Run following to get dependency cookbooks.

``` bash
berks vendor OpenStack-Vagrant/chef/third-party-cookbooks -b OpenStack-Vagrant/cookbooks/openstack-wrapper/Berksfile
```

Run `vagrant`.

``` bash
cd OpenStack-Vagrant
vagrant up
```

### Optional

To setup sample network and create test instances run following on `controller` node:

``` bash
chef-client -z -o openstack-wrapper::sample_network --config /vagrant/chef/client.rb
```
