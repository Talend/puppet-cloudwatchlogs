require 'spec_helper'

describe 'cloudwatchlogs' do
  describe file('/var/log/awslogs.log'), :retry => 3, :retry_wait => 10 do
    its(:content) { should include 'Log group: acceptance_test, log stream: thisIsABeakerTestHost' }
  end

  describe file('/var/log/awslogs.log'), :retry => 3, :retry_wait => 10 do
    its(:content) { should_not include 'ERROR' }
  end

  describe service('awslogs') do
    it { should be_running }
  end
end
