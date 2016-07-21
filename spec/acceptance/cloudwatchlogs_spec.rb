require 'spec_helper'

describe 'cloudwatchlogs' do

  describe 'log file content', :retry => 5, :retry_wait => 10 do
    subject { file('/var/log/awslogs.log').content }
    it { should include 'Log group: acceptance_test, log stream: thisIsATestHost' }
  end

  describe file('/var/log/awslogs.log') do
    its(:content) { should_not include 'ERROR' }
  end

  describe service('awslogs') do
    it { should be_running }
  end
end
