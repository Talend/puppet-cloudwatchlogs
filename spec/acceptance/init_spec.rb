require 'spec_helper_acceptance'


describe "cloudwatchlogs" do
  let(:pp) do
    <<-EOS
    cloudwatchlogs::log{'Beakertest'
      path            => '/var/log/messages',
      streamname      => 'thisIsABeakerTestHost'
    }
    EOS
  end

  it_behaves_like 'puppet::appliable', :pp

  context 'should have cloudwatchlogs role configured' do

    describe file('/var/log/awslogs.log'), :retry => 3, :retry_wait => 10 do

      # TODO: missing wait condition makes this fail
      # its(:content) { should match /Log group:\ \/talend\/tic\/base\/var\/log\/audit,\ log stream/ }
      # its(:content) { should match /Log group:\ \/talend\/tic\/base\/var\/log\/messages,\ log stream/ }
      its(:content) { should match /Log group:\ thisIsABeakerTestHost\/Beakertest,\ log stream/ }

      its(:content) { should_not match /ERROR:/ }
    end

  end


end

