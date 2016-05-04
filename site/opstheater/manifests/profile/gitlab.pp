# opstheater::profile::gitlab

# this class configures a gitlab instance for opstheater

class opstheater::profile::gitlab {

  $gitlab_use_ssl             = ( if hiera('opstheater::http_mode') == 'https' { true } else { false } )
  $gitlab_url                 = hiera('opstheater::profile::gitlab::gitlab_url')
  $gitlab_fqdn                = hiera('opstheater::profile::gitlab::gitlab_fqdn')
  $gitlab_ipaddress           = hiera('opstheater::profile::gitlab::gitlab_ipaddress')
  $gitlabci_url               = hiera('opstheater::profile::gitlab::gitlab_url')
  $gitlab_smtp_authentication = ( if hiera('opstheater::smtp::auth_type') in (['none','login','plain']) { hiera('opstheater::smtp::auth_type') } else { 'none' } )
  $gitlab_enable_tls          = ( if hiera('opstheater::smtp::ssl_type') in (['TLS','STARTTLS']) == true { true } else { false })
  $gitlab_starttls_auto       = ( if hiera('opstheater::smtp::ssl_type') == 'STARTTLS' { true } else { false } )

  $github_oauth_enabled      = hiera('opstheater::profile::gitlab::github_oauth_enabled')
  $github_oauth_clientid     = hiera('opstheater::profile::gitlab::github_oauth_clientid')
  $github_oauth_clientsecret = hiera('opstheater::profile::gitlab::github_oauth_clientsecret')
  $github_oauth_uri          = hiera('opstheater::profile::gitlab::github_oauth_uri')

  $mattermost_url                 = hiera('opstheater::profile::gitlab::mattermost_url')
  $mattermost_fqdn                = hiera('opstheater::profile::gitlab::mattermost_fqdn')
  $mattermost_connection_security = ( if hiera('opstheater::smtp::ssl_type') in (['TLS','STARTTLS']) { hiera('opstheater::smtp::ssl_type') } else { '' } )

  $email_smtp_username = ( if hiera('opstheater::smtp::auth_type') != false { hiera('opstheater::smtp::username') } else {''} )
  $email_smtp_password = ( if hiera('opstheater::smtp::auth_type') != false { hiera('opstheater::smtp::password') } else {''} )

  $gitlab_api_endpoint = hiera('opstheater::profile::gitlab::api_endpoint')
  $gitlab_api_user     = hiera('opstheater::profile::gitlab::api_user')
  $gitlab_api_password = hiera('opstheater::profile::gitlab::api_password')

  $gitlab_ssl_cert = "/etc/gitlab/ssl/${gitlab_fqdn}.crt";
  $mattermost_ssl_cert = "/etc/gitlab/ssl/${mattermost_fqdn}.crt";

  host { $mattermost_fqdn:
    ensure => present,
    ip     => $gitlab_ipaddress,
  } ->

  # NOTE: it shouldn't be needed to define the user and file resources here,
  # this should be fixed in the omnibus installer
  user { 'gitlab-ci':
    ensure  => present,
    comment => 'Gitlab CI user',
    home    => '/var/opt/gitlab/gitlab-ci',
    shell   => '/bin/false',
  } ->

  # Some ssl keys for gitlab
  file { ['/etc/gitlab', '/etc/gitlab/ssl'] :
    ensure => directory,
    mode   => '0700',
  } ->

  file { "/etc/gitlab/ssl/${gitlab_fqdn}.key" :
    ensure => file,
    source => 'puppet:///modules/opstheater/ssl/gitlab.key',
    notify => Exec['gitlab_reconfigure'],
  } ->

  # Create our SSL Cert for Gitlab Nginx specifically for Nginx with the CACert
  # combined with the cert
  concat{ $gitlab_ssl_cert:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['gitlab_reconfigure'],
  }

  concat::fragment{'gitlab_ssl_cert_data':
    target => $gitlab_ssl_cert,
    source => 'puppet:///modules/opstheater/ssl/gitlab.crt',
    order  => 10,
  }

  concat::fragment{'gitlab_ssl_cacert_data':
    target => $gitlab_ssl_cert,
    source => 'puppet:///modules/opstheater/ssl/gitlab-cabundle.crt',
    order  => 20,
  }

  file { "/etc/gitlab/ssl/${mattermost_fqdn}.key" :
    ensure => file,
    source => 'puppet:///modules/opstheater/ssl/mattermost.key',
    notify => Exec['gitlab_reconfigure'],
  } ->

  # Create our SSL Cert for Mattermost Nginx specifically for Nginx with the
  # CACert combined with the cert
  concat{ $mattermost_ssl_cert:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['gitlab_reconfigure'],
  }

  concat::fragment{'mattermost_ssl_cert_data':
    target => $mattermost_ssl_cert,
    source => 'puppet:///modules/opstheater/ssl/mattermost.crt',
    order  => 10,
  }

  concat::fragment{'mattermost_ssl_cacert_data':
    target => $mattermost_ssl_cert,
    source => 'puppet:///modules/opstheater/ssl/mattermost-cabundle.crt',
    order  => 20,
  }

  # make sure some of the basic directories exist
  file { '/var/opt/gitlab':
    ensure => directory,
    notify => Exec['gitlab_reconfigure']
  } ->

  file { '/var/opt/gitlab/nginx':
    ensure => directory,
  } ->

  file { '/var/opt/gitlab/nginx/conf':
    ensure => directory,
  } ->

  # configure gitlab. The *_url attributes determine wether that subsystem should be configured
  # For SMTP Stuff: http://doc.gitlab.com/omnibus/settings/smtp.html#examples
  class { '::gitlab':
    external_url            => $gitlab_url,
    mattermost_external_url => $mattermost_url,
    mattermost              => {
      team_site_name                        => 'OpsTheater Mattermost by OlinData',
      log_enable_file                       => true,
      service_enable_incoming_webhooks      => true,
      service_enable_post_username_override => true,
      service_enable_post_icon_override     => true,
      service_enable_outgoing_webhooks      => true,
      email_enable_sign_up_with_email       => false,
      email_smtp_server                     => hiera('opstheater::smtp::fqdn'),
      email_smtp_username                   => $email_smtp_username,
      email_smtp_password                   => $email_smtp_password,
      email_smtp_port                       => hiera('opstheater::smtp::port'),
      email_connection_security             => $mattermost_connection_security,
      email_feedback_name                   => 'OpsTheater Mattermost',
      email_feedback_email                  => "mattermost@${mattermost_fqdn}",
      team_enable_team_listing              => true,
      team_enable_team_creation             => false,  #NOTE: This must be TRUE for the initial team to setup mattermost then its always false afterwards
      team_enable_user_creation             => true,
      email_send_email_notifications        => true,
      service_use_ssl                       => $gitlab_use_ssl,
    },
    mattermost_nginx        => {
      redirect_http_to_https => $gitlab_use_ssl,
      ssl_certificate        => "/etc/gitlab/ssl/${mattermost_fqdn}.crt",
      ssl_certificate_key    => "/etc/gitlab/ssl/${mattermost_fqdn}.key",
    },
    gitlab_rails            => {
      smtp_enable               => true,
      smtp_address              => hiera('opstheater::smtp::fqdn'),
      smtp_port                 => hiera('opstheater::smtp::port'),
      smtp_user_name            => hiera('opstheater::smtp::username'),
      smtp_password             => hiera('opstheater::smtp::password'),
      smtp_domain               => hiera('opstheater::domain'),
      smtp_authentication       => $gitlab_smtp_authentication,
      smtp_enable_starttls_auto => $gitlab_starttls_auto,
      smtp_tls                  => $gitlab_enable_tls,
      smtp_openssl_verify_mode  => hiera('opstheater::smtp::openssl_verify_mode'),
      omniauth_providers        => [ {
        name       => 'github',
        app_id     => $github_oauth_clientid,
        app_secret => $github_oauth_clientsecret,
        url        => $github_oauth_uri,
        args       => {
          'scope' => 'user:email'
        }
      } ],
    },
    nginx                   => {
      redirect_http_to_https => $gitlab_use_ssl,
    },
  }

  include opstheater::profile::filebeat::gitlab
  include opstheater::profile::filebeat::mattermost

}
