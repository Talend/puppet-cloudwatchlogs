file { '/root/.aws':
  ensure => directory,
} ->
file { '/root/.aws/credentials':
  content => "[default]
aws_access_key_id = ${::aws_access_key_id}
aws_secret_access_key = ${::aws_secret_access_key}
"
} ->
cloudwatchlogs::log { 'acceptance_test':
  path       => '/var/log/messages',
  streamname => 'thisIsATestHost',
}
