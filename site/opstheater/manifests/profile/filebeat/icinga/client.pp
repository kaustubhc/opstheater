class opstheater::profile::filebeat::icinga::client {

  filebeat::prospector { 'icingalogs':
    paths    => [
      '/var/log/icinga2/icinga2.log',
      '/var/log/icinga2/error.log',
    ],
    log_type => 'icinga-beat',
  }

}
