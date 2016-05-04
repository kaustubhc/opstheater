class opstheater::role::elastic::server {

  include opstheater::profile::base
  include opstheater::profile::elasticsearch
  include opstheater::profile::kibana
  include opstheater::profile::logstash
  include opstheater::profile::grafana

}
