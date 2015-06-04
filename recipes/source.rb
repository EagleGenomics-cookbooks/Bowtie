#
# Cookbook Name:: Bowtie
# Recipe:: source
#
# Copyright (c) 2015 Eagle Genomics, All Rights Reserved.

include_recipe 'build-essential'

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
