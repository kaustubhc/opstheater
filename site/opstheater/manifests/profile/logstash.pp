class opstheater::profile::logstash {

  include opstheater::profile::filebeat::logstash

  $package_url               = hiera('opstheater::profile::logstash::package_url')
  $input_beats_port          = hiera('opstheater::profile::logstash::input_beats_port')
  $input_beats_type          = hiera('opstheater::profile::logstash::input_beats_type')
  $output_elasicsearch_hosts = hiera_array('opstheater::profile::logstash::output_elasticsearch_hosts', undef)
  $output_codec              = hiera('opstheater::profile::logstash::output_codec')
  $plugins                   = hiera_hash('opstheater::profile::logstash::plugins', undef)

  class { 'logstash':
    package_url  => $package_url,
    java_install => true,
  }

  logstash::configfile { 'input_beats':
    content => template('opstheater/input_beats.erb'),
    order   => 1,
  }

  logstash::configfile { 'filter':
    content => template('opstheater/filter.erb'),
    order   => 2,
  }

  logstash::configfile { 'output_header':
    content => template('opstheater/output_header.erb'),
    order   => 3,
  }

  logstash::configfile { 'output_elasticsearch':
    content => template('opstheater/output_elasticsearch.erb'),
    order   => 4,
  }

  logstash::configfile { 'output_footer':
    content => template('opstheater/output_footer.erb'),
    order   => 99,
  }

  if $plugins {
    create_resources('logstash::plugin', $plugins)
  }

}
