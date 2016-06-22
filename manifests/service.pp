class cloudwatchlogs::service (
  $region = $cloudwatchlogs::region,
  $ensure = $cloudwatchlogs::service_ensure
){

  if $ensure == 'stopped' {
    $_enable = false
  } else {
    $_enable = true
  }

  exec { 'cloudwatchlogs-install':
    path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
    command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
    onlyif  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
    unless  => '[ -d /var/awslogs/bin ]',
    require => Concat['/etc/awslogs/awslogs.conf'],
  } ->

  service { 'awslogs':
    ensure => $ensure,
    enable => $_enable,
  }

}
