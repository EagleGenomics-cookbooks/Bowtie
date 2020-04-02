#
# Cookbook:: Bowtie
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'Bowtie::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '18.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
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
