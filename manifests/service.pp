class cloudwatchlogs::service (

  $region     = $::cloudwatchlogs::region,

){


  # TODO: This is a mess but the installer requires an exiting /etc/awslogs/awslogs.conf
  # TODO: This will move to s3 later on like this -c s3://myawsbucket/my-config-file
  exec { 'cloudwatchlogs-install':
    path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
    command => "python /usr/local/src/awslogs-agent-setup.py -n -r ${region} -c /etc/awslogs/awslogs.conf",
    onlyif  => '[ -e /usr/local/src/awslogs-agent-setup.py ]',
    unless  => '[ -d /var/awslogs/bin ]',
    require => Concat['/etc/awslogs/awslogs.conf'],
  } ->

  service { 'awslogs':
    ensure     => 'running',
    enable     => true,
  }

}