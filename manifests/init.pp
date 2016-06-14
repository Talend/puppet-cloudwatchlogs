# Class: cloudwatchlogs
# ===========================
#
# Full description of class cloudwatchlogs here.
#
#
# Variables
# ----------
#
# * `state_file`
#  Explanation of how this variable affects the function of this class and if
#
# * `region`
#  Explanation of how this variable affects the function of this class and if
#
# Examples
# --------
#
# @example
#    class { 'cloudwatchlogs':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <andreas.heumaier@nordcloud.com>
#
# Copyright
# ---------
#
# Copyright 2016 Talend, unless otherwise noted.
#
class cloudwatchlogs (

  $state_file = $::cloudwatchlogs::params::state_file,
  $region     = $::cloudwatchlogs::params::region,

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
