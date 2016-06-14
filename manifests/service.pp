class cloudwatchlogs::service {

  service { 'awslogs':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}