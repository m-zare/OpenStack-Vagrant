ssl_cert_file =
  File.join(node['openstack']['dashboard']['ssl']['cert_dir'], node['openstack']['dashboard']['ssl']['cert'])
ssl_key_file =
  File.join(node['openstack']['dashboard']['ssl']['key_dir'], node['openstack']['dashboard']['ssl']['key'])
ssl_chain_file =
  if node['openstack']['dashboard']['ssl']['chain']
    File.join(node['openstack']['dashboard']['ssl']['cert_dir'], node['openstack']['dashboard']['ssl']['chain'])
  end

ssl_cert = node['openstack']['dashboard']['ssl']['content']['cert']
ssl_key = node['openstack']['dashboard']['ssl']['content']['key']
ssl_chain = node['openstack']['dashboard']['ssl']['content']['chain']

if node['openstack']['dashboard']['use_ssl']
  unless ssl_cert_file == ssl_key_file
    cert_mode = '644'
    cert_owner = 'root'
    cert_group = 'root'

    file ssl_cert_file do
      content ssl_cert
      mode cert_mode
      owner cert_owner
      group cert_group
    end
  end

  if ssl_chain_file
    cert_mode = '644'
    cert_owner = 'root'
    cert_group = 'root'

    file ssl_chain_file do
      content ssl_chain
      mode cert_mode
      owner cert_owner
      group cert_group
    end
  end

  key_mode = '640'
  key_owner = 'root'
  key_group = node['openstack']['dashboard']['key_group']

  file ssl_key_file do
    content ssl_key
    mode key_mode
    owner key_owner
    group key_group
  end
end
