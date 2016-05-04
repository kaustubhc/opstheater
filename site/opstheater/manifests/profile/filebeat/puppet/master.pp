class opstheater::profile::filebeat::puppet::master{

  filebeat::prospector { 'puppetserver':
    paths    => [
      '/var/log/puppetlabs/puppetserver/puppetserver.log',
      '/var/log/puppetlabs/puppetserver/puppetserver-access.log',
    ],
    log_type => 'puppetserver-beat',
  }

  filebeat::prospector { 'puppetcs':
    paths    => [
      '/var/log/puppetlabs/console-services/console-services.log',
      '/var/log/puppetlabs/console-services/console-services-access.log',
    ],
    log_type => 'puppetcs-beat',
  }

  filebeat::prospector { 'nginxlogs':
    paths    => [
      '/var/log/puppetlabs/nginx/access.log',
      '/var/log/puppetlabs/nginx/error.log',
    ],
    log_type => 'nginx-beat',
  }

}

