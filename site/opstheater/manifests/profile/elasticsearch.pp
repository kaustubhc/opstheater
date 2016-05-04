#class profile::elasticsearch inherits profile::base{

class opstheater::profile::elasticsearch{
  # resources required for elasticsearch
  include ::java
  include opstheater::profile::filebeat::elasticsearch
  
  class { '::elasticsearch':
  }
  
  # load elasticsearch instance details fore hiera
  $instances = hiera_hash('opstheater::profile::elasticsearch::instances', undef)
  
  if $instances {
    create_resources('elasticsearch::instance', $instances)
  } else {
    fail("No elasticsearch instances found in hiera for class opstheater::profile::elasticsearch on ${::fqdn}.")
  }
    
}
