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

if platform == 'ubuntu' || platform == 'debian'
  template '/etc/nginx/sites-available/default' do
    source 'lb.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, 'service[nginx]', :immediately
  end
  cookbook_file '/etc/nginx/nginx.conf' do
    source 'nginx.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
else
  template '/etc/nginx/conf.d/default.conf' do
    source 'lb.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, 'service[nginx]', :immediately
  end
end

if platform == 'ubuntu' || platform == 'debian'
  service 'nginx' do
    action [:start, :enable]
    subscribes :restart, 'template[/etc/nginx/sites-available/default', :immediately
  end
else
  service 'nginx' do
    action [:start, :enable]
    subscribes :restart, 'template[/etc/nginx/conf.d/default.conf', :immediately
  end
end




