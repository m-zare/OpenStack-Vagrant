# OpenStack-Vagrant

## Requirements

- [Chef Workstation](https://downloads.chef.io/products/workstation)
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or any other cd [provider](https://www.vagrantup.com/docs/providers) supported by vagrant)

## How to

Clone/download this repo.

Run following to get dependency cookbooks.

``` bash
berks vendor vagrant/chef/third-party-cookbooks -b vagrant/cookbooks/openstack_wrapper/Berksfile
```

Run `vagrant`.

``` bash
cd vagrant/
vagrant up
```

### Optional

To setup sample network and create test instances:

``` bash
chef-client -z -o openstack_wrapper::sample_network --config /vagrant/chef/client.rb
```
