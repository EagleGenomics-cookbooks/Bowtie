#
# Cookbook Name:: Bowtie
# Recipe:: default
#
# Copyright (c) 2016 Eagle Genomics Ltd, Apache License, Version 2.0.
include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'locale' if node['platform_family'] == 'debian'

if node['platform_family'] == 'debian'
  package ['zlib1g-dev'] do
    action :install
  end
elsif node['platform_family'] == 'rhel'
  package ['zlib-devel', 'epel-release'] do
    action :install
  end
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
end

package %w(clang tar unzip) do
  action :install
end

##########################################################

include_recipe 'build-essential'

##########################################################

bowtie_version = node['Bowtie']['version']
bowtie_name = 'bowtie'
bowtie_base_name = "#{bowtie_name}-#{bowtie_version}"
bowtie_file_name = "#{bowtie_base_name}-src.zip"
# override the bowtie_name and bowtie_file_name for bowtie2
if bowtie_version =~ /^2/
  bowtie_name = 'bowtie2'
  bowtie_base_name = "#{bowtie_name}-#{bowtie_version}"
  bowtie_file_name = "#{bowtie_base_name}-source.zip"
end
bowtie_download_url = "http://sourceforge.net/projects/bowtie-bio/files/#{bowtie_name}/#{bowtie_version}/#{bowtie_file_name}"

remote_file "#{Chef::Config[:file_cache_path]}/#{bowtie_file_name}" do
  source bowtie_download_url
end

execute "Unzip #{bowtie_file_name}" do
  command "unzip #{bowtie_file_name} -d #{node['Bowtie']['install_path']}"
  cwd Chef::Config[:file_cache_path]
  not_if { ::File.exist?("#{node['Bowtie']['install_path']}/#{bowtie_base_name}") }
end

bash 'Install Bowtie' do
  cwd "#{node['Bowtie']['install_path']}/#{bowtie_base_name}"
  code 'make'
  not_if { ::File.exist?("#{node['Bowtie']['install_path']}/#{bowtie_base_name}/bowtie-build-l") }
end

execute "find #{node['Bowtie']['install_path']}/#{bowtie_base_name} -maxdepth 1 -name 'bowtie*' -executable -type f -exec ln -s {}  #{node['Bowtie']['install_path']}/bin \\;" do
end

# record the tool version for report generation
magic_shell_environment 'BOWTIE_VERSION' do
  value node['Bowtie']['version']
end

# put the install location onto the PATH, so other tools can reuse it
magic_shell_environment 'PATH' do
  # filename 'bowtie_path'
  value "$PATH:#{node['Bowtie']['install_path']}/#{bowtie_base_name}"
end
