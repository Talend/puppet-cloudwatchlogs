class cloudwatchlogs::service (

  $region = $cloudwatchlogs::region,
  $ensure = $cloudwatchlogs::service_ensure,

){

  if $ensure == 'stopped' {
    $_enable = false
  } else {
    $_enable = true
  }

  exec { 'cloudwatchlogs-install':
    path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
    command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
    onlyif  => '/bin/test -f /usr/local/src/awslogs-agent-setup.py',
    unless  => '/bin/test -d /var/awslogs/bin',
    require => Concat['/etc/awslogs/awslogs.conf'],
  }

  exec { 'pyenv-update-pip':
    command => '/var/awslogs/bin/pip install -U pip && /bin/touch /var/awslogs/.pip_updated',
    unless  => '/bin/test -f /var/awslogs/.pip_updated',
    require => Exec['cloudwatchlogs-install']
  }

  exec { 'pyenv-update-setuptools':
    command => '/var/awslogs/bin/pip install -U setuptools && /bin/touch /var/awslogs/.setuptools_updated',
    unless  => '/bin/test -f /var/awslogs/.setuptools_updated',
    require => Exec['pyenv-update-pip']
  }

  exec { 'cloudwatchlogs-update-config':
    command => "/var/awslogs/bin/python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
    onlyif  => '/bin/test /etc/awslogs/awslogs.conf -nt /var/awslogs/etc/awslogs.conf',
    require => [
      Exec['cloudwatchlogs-install'],
      Exec['pyenv-update-pip'],
      Exec['pyenv-update-setuptools']
    ]
  } ~>

  service { 'awslogs':
    ensure => $ensure,
    enable => $_enable,
  }

}
