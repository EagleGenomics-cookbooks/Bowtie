default['Bowtie']['version'] = '1.1.1'
default['Bowtie']['dirname'] = "bowtie-#{node['Bowtie']['version']}"
default['Bowtie']['filename'] = "bowtie-#{node['Bowtie']['version']}-src.zip"
default['Bowtie']['url'] = "http://sourceforge.net/projects/bowtie-bio/files/\
bowtie/#{node['Bowtie']['version']}/#{node['Bowtie']['filename']}"
default['Bowtie']['install_path'] = '/usr/local/bin'
