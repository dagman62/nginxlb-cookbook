
platform = node['platform']
if platform == 'centos'
  node.default['distro'] = node['platform']
elsif platform == 'fedora'
  node.default['distro'] = 'rhel'
else
  node.default['distro'] = node['platform']
end

node.default['nginx']['web1'] = 'dragon.example.com'
node.default['nginx']['web2'] = 'shadow.example.com'
node.default['nginx']['web3'] = 'hornet.example.com'
node.default['nginx']['web4'] = 'mercury.example.com'
