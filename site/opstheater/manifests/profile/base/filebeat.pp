class opstheater::profile::base::filebeat{

  $logstash_fqdn = hiera('opstheater::logstash::fqdn')

  class { 'filebeat':
    outputs => {
      'logstash' => {
        'hosts'       => [
          "${logstash_fqdn}:5044",
        ],
        'loadbalance' => true,
        'enabled'     => true,
      },
    },
  }

  filebeat::prospector { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/messages',
    ],
    log_type => 'syslog-beat',
  }

}
