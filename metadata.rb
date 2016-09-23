name 'Bowtie'
maintainer 'Eagle Genomics'
maintainer_email 'chef@eaglegenomics.com'
license 'Apache v2.0'
description 'Installs/Configures Bowtie'
long_description 'Installs/Configures Bowtie'
version '1.0.6'

source_url 'https://github.com/EagleGenomics-cookbooks/Bowtie'
issues_url 'https://github.com/EagleGenomics-cookbooks/Bowtie/issues'

supports 'centos', '= 6.5'
supports 'centos', '= 7.0'
supports 'ubuntu', '= 14.04'

depends 'build-essential'
depends 'magic_shell'
depends 'apt'
depends 'locale'
