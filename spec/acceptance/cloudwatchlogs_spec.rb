require 'spec_helper'

describe 'cloudwatchlogs' do
  describe file('/var/log/awslogs.log') do
    its(:content) { should_not include 'ERROR' }
  end

  describe service('awslogs') do
    it { should be_running }
  end
end
