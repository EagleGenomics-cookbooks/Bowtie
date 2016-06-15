#
# Cookbook Name:: Bowtie
# Recipe:: source
#
# Copyright (c) 2016 Eagle Genomics Ltd, Apache License, Version 2.0.
##########################################################

package ['zlib-devel', 'tar', 'unzip', 'epel-release']

if node['platform'] == 'centos' && node['platform_version'] =~ /^7\./
  # Pre-load compatible llvm-libs version before we encounter epel/extras conflicts with clang
  # Package: llvm-3.4.2-7.el7.x86_64 (extras)
  # Requires: llvm-libs(x86-64) = 3.4.2-7.el7
  # manual install of clang uses 3.4.2-8 and epel successfully
  # but package 'clang' uses extras llvm 3.4.2-7 and then epel lbvm-libs 3.4.2-8?!
  # somehow package 'clang' forces older release of llvm only
  execute 'yum -y install llvm-libs-3.4.2-7.el7'
  # package cannot handle the version-release in the name
  # and does not support release at all?
end

package 'clang'

##########################################################

include_recipe 'build-essential'

##########################################################

node.default['Bowtie']['dirname'] = "bowtie-#{node['Bowtie']['version']}"
node.default['Bowtie']['filename'] = "bowtie-#{node['Bowtie']['version']}-src.zip"
node.default['Bowtie']['url'] = "http://sourceforge.net/projects/bowtie-bio/files/bowtie/#{node['Bowtie']['version']}/#{node['Bowtie']['filename']}"

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
