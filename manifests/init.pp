# Class: cloudwatchlogs
#
class cloudwatchlogs (
  $state_file     = $cloudwatchlogs::params::state_file,
  $region         = $cloudwatchlogs::params::region,
  $service_ensure = 'running'
) inherits cloudwatchlogs::params {

  validate_absolute_path($state_file)
  validate_string($region)

  class { 'cloudwatchlogs::install': }
  class { 'cloudwatchlogs::config': }
  class { 'cloudwatchlogs::service': }

  anchor { 'cloudwatchlogs::begin': }
  anchor { 'cloudwatchlogs::end': }

  Anchor['cloudwatchlogs::begin'] ->
    Class['cloudwatchlogs::install'] ->
    Class['cloudwatchlogs::config'] ~>
    Class['cloudwatchlogs::service'] ->
  Anchor['cloudwatchlogs::end']

}
