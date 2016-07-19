class cloudwatchlogs::install {

  include ::wget
  wget::fetch { 'https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py':
    destination => '/usr/local/src/',
    verbose     => false,
  }

}
