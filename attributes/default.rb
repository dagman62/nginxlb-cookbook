
platform = node['platform']
if platform == 'centos'
  node.default['distro'] = node['platform']
elsif platform == 'fedora'
  node.default['distro'] = 'rhel'
else
  node.default['distro'] = node['platform']
end

default['nginx']['server']['web1'] = 'dragon.example.com'
default['nginx']['server']['web2'] = 'shadow.example.com'
default['nginx']['server']['web3'] = 'hornet.example.com'
default['nginx']['server']['web4'] = ''
default['nginx']['server']['web5'] = ''
default['nginx']['server']['web6'] = ''
