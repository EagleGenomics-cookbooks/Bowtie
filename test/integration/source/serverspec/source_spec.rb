require 'serverspec'
require_relative 'spec_helper'

# Required by serverspec
set :backend, :exec

# tests for executables
%w(bowtie-inspect-s bowtie-align-l bowtie-align-s bowtie-build-l bowtie-build-s bowtie bowtie-build
   bowtie-inspect).each do |file_executable|
  describe command("which #{file_executable}") do
    its(:exit_status) { should eq 0 }
  end

  describe command("#{file_executable} --version") do
    its(:stdout) { should contain(ENV['BOWTIE_VERSION']) }
  end
end
