#
# Cookbook Name:: Bowtie
# Recipe:: source
#
# Copyright (c) 2015 Eagle Genomics, All Rights Reserved.

log 'Starting Bowtie recipe'

include_recipe 'build-essential'

# Placed here for use by serverspec
cookbook_file 'default_attributes.rb' do
  path '/tmp/default_attributes.rb'
  action :create
  owner 'root'
  group 'root'
  mode 0755
end

package 'unzip' do
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['Bowtie']['filename']}" do
  source node['Bowtie']['url']
end

execute "Unzip #{node['Bowtie']['filename']}" do
  command "unzip #{node['Bowtie']['filename']} -d #{node['Bowtie']['install_path']}"
  cwd Chef::Config[:file_cache_path]
  not_if { ::File.exist?("#{node['Bowtie']['install_path']}/#{node['Bowtie']['dirname']}") }
end

bash 'Install Bowtie' do
  cwd "#{node['Bowtie']['install_path']}/#{node['Bowtie']['dirname']}"
  code 'make'
  not_if { ::File.exist?("#{node['Bowtie']['install_path']}/#{node['Bowtie']['dirname']}/bowtie-build-l") }
end

execute "find #{node['Bowtie']['install_path']}/#{node['Bowtie']['dirname']} -maxdepth 1 -name 'bowtie*' -executable -type f -exec ln -s {} . \\;" do
  cwd "{node['Subread']['bin_path']}/bin"
end

log 'Finished Bowtie recipe'
