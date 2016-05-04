class opstheater::profile::filebeat::kibana {

  filebeat::prospector { 'kibanalogs':
    paths    => [
      '/var/log/kibana/kibana4.log',
      '/var/log/kibana4.log',
      '/var/log/kibana4.err',
    ],
    log_type => 'kibanalogs-beat',
  }

}

