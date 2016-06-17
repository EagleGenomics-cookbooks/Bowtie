#
# Cookbook Name:: Bowtie
# Recipe:: source
#
# Copyright (c) 2016 Eagle Genomics Ltd, Apache License, Version 2.0.
##########################################################
# package install

if node['platform_family'] == 'debian'
  package ['zlib1g-dev'] do
    action :install
  end
elsif node['platform_family'] == 'rhel'
  package ['zlib-devel', 'epel-release'] do
    action :install
  end
end

package %w(clang tar unzip) do
  action :install
end

##########################################################

include_recipe 'build-essential'

##########################################################

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

execute "find #{node['Bowtie']['install_path']}/#{node['Bowtie']['dirname']} -maxdepth 1 -name 'bowtie*' -executable -type f -exec ln -s {}  #{node['Bowtie']['install_path']}/bin \\;" do
end

##########################################################
# here for use by serverspecs

magic_shell_environment 'BOWTIE_VERSION' do
  value node['Bowtie']['version']
end

##########################################################
