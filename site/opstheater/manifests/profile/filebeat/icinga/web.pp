class opstheater::profile::filebeat::icinga::web {

  filebeat::prospector { 'icingaweblogs':
    paths    => [
      '/var/log/icingaweb2/*.log',
    ],
    log_type => 'icinga-beat',
  }

}
