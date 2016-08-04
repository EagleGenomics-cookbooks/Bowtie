#
# Cookbook Name:: Bowtie
# Spec:: default
#
# Copyright (c) 2016 Eagle Genomics Ltd, Apache License, Version 2.0.

require 'spec_helper'

describe 'Bowtie::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'includes the `build-essential` recipe' do
      expect(chef_run).to include_recipe('build-essential')
    end

    it 'installs clang, tar, unzip' do
      expect(chef_run).to install_package 'clang, tar, unzip'
    end

    it 'adds a new magic_shell_environment' do
      expect(chef_run).to add_magic_shell_environment('BOWTIE_VERSION')
    end
  end
end
