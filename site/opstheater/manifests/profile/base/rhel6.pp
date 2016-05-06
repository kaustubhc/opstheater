class opstheater::profile::base::rhel6 {
  include epel

  # get repos from hiera and create them
  $repositories = hiera_hash('opstheater::profile::base::yum::repositories', undef)
  if $repositories {
    create_resources('yumrepo', $repositories)
  }

  # Adding Logstash
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

  Icinga2::Object::Host {
    display_name    => $::fqdn,
    check_command   => 'cluster-zone',
    target_dir      => '/etc/icinga2/objects/hosts',
    target_file_name=> "${::fqdn}.conf",
  }

  @@icinga2::object::host { $::fqdn:
    ipv4_address => $::ipaddress,
    vars         => {
      os              => 'Linux',
      remote          => true,
      remote_endpoint => $::fqdn
    },
  }


}
