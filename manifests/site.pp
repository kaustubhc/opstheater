# runs puppet enterprise or puppet open source
node 'master.opstheater.vm' {
  include opstheater::role::puppet::master
}

# runs elasticsearch, logstash, kibana and grafana
node 'elasticsearch.opstheater.vm' {
  include opstheater::role::elastic::server
}

# runs gitlab, gitlab CI and mattermost
node 'gitlab.opstheater.vm' {
  include opstheater::role::gitlab::server
}

# runs standalone monitoring setup with icinga2 and icinga web2
node 'icinga2.opstheater.vm' {
  include opstheater::role::monitoring::standalone
}

node 'mysql.opstheater.vm' {
  include opstheater::role::database::standalone
}

node default {
  include opstheater::role::testclient
}
