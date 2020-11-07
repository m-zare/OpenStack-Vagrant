# provider network
execute 'create provider network' do
  command '. /root/openrc;openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider'
  not_if '. /root/openrc;openstack network show provider'
end
execute 'create provider subnet' do
  command ". /root/openrc;openstack subnet create --network provider --allocation-pool start=#{node['sample']['network']['provider']['start']},end=#{node['sample']['network']['provider']['end']} --dns-nameserver #{node['sample']['network']['dns']} --gateway #{node['sample']['network']['provider']['gateway']} --subnet-range #{node['sample']['network']['provider']['subnet']} provider"
  not_if '. /root/openrc;openstack subnet show provider'
end

# selfservice network
execute 'create selfservice network' do
  command '. /root/openrc;openstack network create selfservice'
  not_if '. /root/openrc;openstack network show selfservice'
end
execute 'create selfservice subnet' do
  command ". /root/openrc;openstack subnet create --network selfservice --allocation-pool start=#{node['sample']['network']['selfservice']['start']},end=#{node['sample']['network']['selfservice']['end']} --dns-nameserver #{node['sample']['network']['dns']} --gateway #{node['sample']['network']['selfservice']['gateway']} --subnet-range #{node['sample']['network']['selfservice']['subnet']} selfservice"
  not_if '. /root/openrc;openstack subnet show selfservice'
end

execute 'create router' do
  command '. /root/openrc;openstack router create router'
  not_if '. /root/openrc;openstack router show router'
end

execute 'add selfservice subnet to the router' do
  environment('subnet_id' => 'openstack subnet list --name selfservice --project admin --column ID --format value')
  command '. /root/openrc;openstack router add subnet router selfservice'
  not_if '. /root/openrc;openstack router show router | grep $($subnet_id)'
end

execute 'set router external gateway' do
  command '. /root/openrc;openstack router set router --external-gateway provider'
end

# allow all input traffic
execute 'allow all input traffic' do
  environment('sec_id' => 'openstack security group list --project admin --column ID --format value')
  command '. /root/openrc;openstack security group rule create $($sec_id)'
  not_if '. /root/openrc;openstack security group rule list $($sec_id) --ingress --column "Remote Security Group" --column "IP Range" --format value| grep None'
end

# flavor
execute 'create flavor' do
  command '. /root/openrc;openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano'
  not_if '. /root/openrc;openstack flavor show 0'
end

# keypair
execute 'create ssh key' do
  command 'ssh-keygen -q -N "" -f /root/.ssh/id_rsa'
  not_if { ::File.exist?('/root/.ssh/id_rsa') }
end
execute 'create keypair' do
  command '. /root/openrc;openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey'
  not_if '. /root/openrc;openstack keypair show mykey'
end

# launch an instance on the provider network
execute 'launch an instance on the provider network' do
  environment(
    'net_id' => 'openstack network list --name provider --project admin --column ID --format value', 'sec_id' => 'openstack security group list --project admin --column ID --format value'
  )
  command '. /root/openrc;openstack server create --nic net-id=$($net_id) --flavor 0 --image cirros --security-group $($sec_id) --key-name mykey provider-instance'
end

#### launch an instance on the self-service network
execute 'launch an instance on the self-service network' do
  environment(
    'net_id' => 'openstack network list --name selfservice --project admin --column ID --format value', 'sec_id' => 'openstack security group list --project admin --column ID --format value'
  )
  command '. /root/openrc;openstack server create --nic net-id=$($net_id) --flavor 0 --image cirros --security-group $($sec_id) --key-name mykey selfservice-instance'
end
