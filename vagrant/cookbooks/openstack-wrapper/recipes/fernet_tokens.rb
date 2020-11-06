key_repository = node['openstack']['identity']['conf']['fernet_tokens']['key_repository']
keystone_user = node['openstack']['identity']['user']
keystone_group = node['openstack']['identity']['group']
platform_options = node['openstack']['identity']['platform']

platform_options['keystone_packages'].each do |pkg|
  package "identity cookbook package #{pkg}" do
    package_name pkg
    options platform_options['package_options']
    action :upgrade
  end
end

directory key_repository do
  owner keystone_user
  group keystone_group
  recursive true
  mode '700'
end

%w(0 1).each do |key_index|
  key = node['openstack']['identity']['fernet'][key_index]
  file File.join(key_repository, key_index.to_s) do
    content key
    owner keystone_user
    group keystone_group
    mode '400'
    sensitive true
  end
end