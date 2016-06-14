class cloudwatchlogs::config (

  $state_file = $::cloudwatchlogs::state_file,
  $region     = $::cloudwatchlogs::region,

){
  case $::operatingsystem {
    /^(Ubuntu|CentOS|RedHat)$/: {

      $state_dirs = ['/var/awslogs','/var/awslogs/etc'  ]
      file { $state_dirs:
        ensure => 'directory',
      }

      file { '/var/awslogs/etc/awslogs.conf':
        ensure => 'link',
        target => '/etc/awslogs/awslogs.conf',
      }
    }
    default: {}
  }

  file { '/etc/awslogs':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  concat { '/etc/awslogs/awslogs.conf':
    ensure         => 'present',
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    ensure_newline => true,
    warn           => true,
    require        => File['/etc/awslogs']
  }

  concat::fragment { 'awslogs-header':
    target  => '/etc/awslogs/awslogs.conf',
    content => template('cloudwatchlogs/awslogs_header.erb'),
    order   => '00',
  }
}