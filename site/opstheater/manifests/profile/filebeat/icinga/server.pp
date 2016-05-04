class opstheater::profile::filebeat::icinga::server {

  filebeat::prospector { 'icingalogs':
    paths    => [
      '/var/log/httpd/*.log',
    ],
    log_type => 'icinga-beat',
  }

}
