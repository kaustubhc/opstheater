class opstheater::profile::kibana {
  
  $elasticsearch = hiera('opstheater::elasticsearch::fqdn')

  # use the standard kibana4 class, the parameters will be loaded from hiera
  class { '::kibana4':
    elasticsearch_url => "http://${elasticsearch}:9200",
  }

  include opstheater::profile::filebeat::kibana

}
