class opstheater::profile::filebeat::foreman::proxy {

  filebeat::prospector { 'foremanproxylogs':
    paths    => [
      '/var/log/foreman-proxy/proxy.log',
    ],
    log_type => 'foreman-beat',
  }

}