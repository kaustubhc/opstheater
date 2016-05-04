class opstheater::profile::foremanproxy {
  
  # Class Defines
  $foreman_fqdn = hiera('opstheater::foreman::fqdn')
  $foreman_url = hiera('opstheater::foreman::url')
  $nginx_ssl_cert = "/etc/nginx/ssl/${foreman_fqdn}.crt";
  $nginx_ssl_key = "/etc/nginx/ssl/${foreman_fqdn}.key";
  
  # Include nginx
  class { 'nginx': }
  
  # Make our nginx ssl directory
  file { ['/etc/nginx/ssl'] :
    ensure => directory,
    mode   => '0755',
    owner  => 'nginx',
    group  => 'nginx',
  }

  include opstheater::profile::filebeat::foreman::proxy
  
  # Create our SSL Key
  file { $nginx_ssl_key :
    ensure  => file,
    source  => 'puppet:///modules/opstheater/ssl/master.key',
    notify  => Class['nginx::service'],
    require => File['/etc/nginx/ssl'],
  }
    
  # Create our SSL Cert for Gitlab Nginx specifically for Nginx with the CACert combined with the cert
  concat{ $nginx_ssl_cert:
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '0600',
    notify  => Class['nginx::service'],
    require => File['/etc/nginx/ssl'],
  }
  concat::fragment{'nginx_ssl_cert_data':
    target => $nginx_ssl_cert,
    source => 'puppet:///modules/opstheater/ssl/master.crt',
    order  => 10,
  }
  concat::fragment{'nginx_ssl_cacert_data':
    target => $nginx_ssl_cert,
    source => 'puppet:///modules/opstheater/ssl/master-cabundle.crt',
    order  => 20,
  }
  
  # If we want to run HTTPS...
  if hiera('opstheater::http_mode') == 'https' {

    # Setup a port-80 forwarding to HTTPS
    # NOTE: Nginx vhost Puppet module requires you to specify either a proxy or a www_root, so the www_root is set 
    #       to an intentionally invalid path which will never be actually used to bypass this unnecessary check
    nginx::resource::vhost { "${foreman_fqdn}.forward":
      ensure           => present,
      rewrite_to_https => true,
      server_name      => [ $foreman_fqdn ],
      www_root         => '/invalid_path_but_must_put_something',
    }

    # Setup a secure proxy to foreman
    nginx::resource::vhost { $foreman_fqdn:
      ensure      => present,
      server_name => [ $foreman_fqdn ],
      listen_port => 443,
      proxy       => 'http://localhost:3000/',
      ssl         => true,
      ssl_port    => 443,
      ssl_cert    => $nginx_ssl_cert,
      ssl_key     => $nginx_ssl_key,
    }
    
  # If we don't want HTTPS...
  } else {
    # Setup a insecure proxy to foreman (for dev envs usually)
    nginx::resource::vhost { $foreman_fqdn:
      ensure      => present,
      server_name => [ $foreman_fqdn ],
      listen_port => 80,
      proxy       => 'http://localhost:3000/',
    }
  }
}
