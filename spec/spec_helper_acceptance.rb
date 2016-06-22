require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'rspec/retry'

run_puppet_install_helper

# Load shared acceptance examples
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__), 'acceptance'))
Dir[base_spec_dir.join('shared/**/*.rb')].sort.each{ |f| require f }

# Load AWS credentials
aws = YAML.load_file(ENV['HOME'] + '/.fog')

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  c.formatter = :documentation
  hosts.each do |host|
    copy_module_to(host, :source => proj_root, :module_name => 'cloudwatchlogs')
    on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
    on host, puppet('module', 'install', 'puppetlabs-concat'), acceptable_exit_codes: [0, 1]
    on host, puppet('module', 'install', 'maestrodev-wget'), acceptable_exit_codes: [0, 1]

    on host, 'mkdir -p /etc/facter/facts.d'
    on host, 'mkdir -p /root/.aws'
    create_remote_file host, '/etc/facter/facts.d/role_facts.txt', "puppet_role=cloudwatchlogs", :protocol => 'rsync'
    create_remote_file host, '/root/.aws/credentials', "[default]\naws_access_key_id=#{aws[:default][:aws_access_key_id]}\naws_secret_access_key=#{aws[:default][:aws_secret_access_key]}", :protocol => 'rsync'
    create_remote_file host, '/root/.aws/config', "[default]\nregion = us-east-1\noutput = json", :protocol => 'rsync'
  end
end
