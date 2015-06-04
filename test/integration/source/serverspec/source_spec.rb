require 'serverspec'
require_relative 'spec_helper'

# Required by serverspec
set :backend, :exec

describe command('which bowtie') do
  its(:exit_status) { should eq 0 }
end

describe command('bowtie --version') do
  its(:stdout) { should match(/bowtie version 1.1.1/) }
end
