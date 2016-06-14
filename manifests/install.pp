class cloudwatchlogs::install (

  $region     = $::cloudwatchlogs::region,

){

  case $::operatingsystem {
    'Amazon': {

      package { 'awslogs':
        ensure => 'present',
      }

    }
    /^(Ubuntu|CentOS|RedHat)$/: {

      if ! defined(Package['wget']) {
        package { 'wget':
          ensure => 'present',
        }
      }

      exec { 'cloudwatchlogs-wget':
        path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        command => 'wget -O /usr/local/src/awslogs-agent-setup.py https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py',
        unless  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
      }

      exec { 'cloudwatchlogs-install':
        path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
        onlyif  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
        unless  => '[ -d /var/awslogs/bin ]',
        require => Concat['/etc/awslogs/awslogs.conf'],
        before  => Service['awslogs'],
      }
    }

    default: { fail('OS is unsupported') }

  }
}