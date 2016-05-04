class opstheater::profile::filebeat::logstash {

  filebeat::prospector { 'logstashlogs':
    paths    => [
      '/var/log/logstash/logstash.log',
      '/var/log/logstash/logstash.err'
    ],
    log_type => 'logstash-beat',
  }

}

