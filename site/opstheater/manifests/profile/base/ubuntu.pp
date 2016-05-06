class opstheater::profile::base::ubuntu {
  # include base aptitude class
  include ::apt

  # get keys from hiera and create them
  $keys = hiera_hash('opstheater::profile::base::apt::keys', undef)
  if $keys {
    create_resources('apt::key', $keys)
  }

  # get repos from hiera and create them
  $repositories = hiera_hash('opstheater::profile::base::apt::repositories', undef)
  if $repositories {
    create_resources('apt::source', $repositories)
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
      '/var/log/syslog',
    ],
    log_type => 'syslog-beat',
  }



  icinga2::Object::Host {
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
