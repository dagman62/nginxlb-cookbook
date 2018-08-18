#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

log "Your Platform is, #{node["distro"]}!" do
  level :info
end

platform = node['platform']

if platform == 'centos' || platform == 'fedora'
  template '/etc/yum.repos.d/nginx.repo' do
    source 'nginx.repo.erb'
      variables ({
        :distro => node['distro']
      })
      action :create
  end
end

if platform == 'centos' || platform == 'fedora'
  bash 'Update cache and Update' do
    code <<-EOH
      yum makecache && yum update -y
      touch /tmp/updated
    EOH
    action :run
    not_if { File.exist?('/tmp/updated') }
  end
end

package 'nginx' do
  action :install
end

if Dir.exist?('/etc/nginx/sites-available')
  template '/etc/nginx/sites-available/default' do
    source 'lb.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables ({
      :web1 => node['nginx']['web1'],
      :web2 => node['nginx']['web2'],
      :web3 => node['nginx']['web3'],
    })
    action :create
  end
else
  template '/etc/nginx/conf.d/default.default.conf' do
    source 'lb.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables ({
      :web1 => node['nginx']['web1'],
      :web2 => node['nginx']['web2'],
      :web3 => node['nginx']['web3'],
    })
    action :create
  end
end

service 'nginx' do
  action [:start, :enable]
end





