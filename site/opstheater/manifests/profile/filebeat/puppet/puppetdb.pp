class opstheater::profile::filebeat::puppet::puppetdb {

  filebeat::prospector { 'puppetdb':
    paths    => [
      '/var/log/puppetlabs/puppetdb/puppetdb.log',
      '/var/log/puppetlabs/puppetdb/puppetdb-access.log',
    ],
    log_type => 'puppetdb-beat',
  }

}