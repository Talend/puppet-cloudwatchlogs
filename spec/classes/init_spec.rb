require 'spec_helper'

describe 'cloudwatchlogs' do
  
  context 'only region on CentOS' do
    let (:params) {{
      :region => 'eu-west-1',
    }}
    let (:facts) {{
      :kernel => 'Linux',
      :operatingsystem => 'CentOS',
      :concat_basedir => '/var/lib/puppet/concat',
    }}

    it { should compile }

    it {

      should contain_concat('/etc/awslogs/awslogs.conf').with({
        'ensure'         => 'present',
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0644',
        'ensure_newline' => 'true',
        'warn'           => 'true',
      })

      should contain_wget__fetch('https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py').with_destination('/usr/local/src/')

      should contain_file('/etc/awslogs').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      })

      should contain_file('/var/awslogs').with_ensure('directory')
      should contain_file('/var/awslogs/etc').with_ensure('directory')
      should contain_exec('cloudwatchlogs-install').with({
        'path'    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        'command' => 'python /usr/local/src/awslogs-agent-setup.py -n -r eu-west-1 -c /etc/awslogs/awslogs.conf',
        'onlyif'  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
        'unless'  => '[ -d /var/awslogs/bin ]',
      })
      should contain_service('awslogs').with({
        'ensure'     => 'running',
        'enable'     => 'true',
      })
    }
  end
  context 'service stopped' do
    let (:params) {{
      :service_ensure => 'stopped',
    }}

    it {
      should contain_service('awslogs').with({
        'ensure'     => 'stopped',
        'enable'     => 'false',
      })
    }

  end
end

