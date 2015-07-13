require 'serverspec'
require_relative 'spec_helper'

# Required by serverspec
set :backend, :exec

set :pre_command, 'source /etc/profile'

set :path, '/usr/local/bin/:$PATH'

# grab chef variables
pseudo_node = PseudoNode.new

puts 'Bowtie version = ' + pseudo_node.default['Bowtie']['version']

# tests for executables
%w(bowtie-inspect-s bowtie-align-l bowtie-align-s bowtie-build-l bowtie-build-s bowtie bowtie-build
   bowtie-inspect).each do |file_executable|
  describe command("which #{file_executable}") do
    its(:exit_status) { should eq 0 }
  end

  describe command("#{file_executable} --version") do
    its(:stdout) { should match(/#{file_executable} version 1.1.1/) }
  end
end
