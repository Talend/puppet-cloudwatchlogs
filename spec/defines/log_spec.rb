require 'spec_helper'

describe 'cloudwatchlogs::log', :type => :define do
  context 'standard log entry' do
    let (:facts) {{
        :operatingsystem => 'CentOS',
        :concat_basedir => '/var/lib/puppet/concat',
    }}

    let (:title) { 'Messages' }
    let (:params) {{
      :path => '/var/log/messages',
    }}
    it {
      should contain_concat__fragment('cloudwatchlogs_fragment_Messages').with_target('/etc/awslogs/awslogs.conf')
    }
  end
end
