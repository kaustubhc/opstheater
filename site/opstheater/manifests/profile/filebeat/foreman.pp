class opstheater::profile::filebeat::foreman {

  filebeat::prospector { 'foremanlogs':
    paths    => [
      '/opt/foreman/log/production.log',
    ],
    log_type => 'foreman-beat',
  }

}

