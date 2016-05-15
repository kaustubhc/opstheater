class opstheater::profile::grafana {
  $grafanauser          = hiera('opstheater::grafana::grafanauser')
  $grafanapasswd        = hiera('opstheater::grafana::grafanapasswd')
  $grafanaurl           = hiera('opstheater::grafana::url')
  $user                 = hiera('opstheater::grafana::influxdb::user')
  $password             = hiera('opstheater::grafana::influxdb::password')

  class { '::grafana': }

  exec { 'elastic_datasource':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => "[ `curl --silent 'http://${grafanauser}:${grafanapasswd}@${grafanaurl}:3000/api/datasources' -X GET | tr ',' '\\n' | grep '\"name\":\"Elastic\"'` == '\"name\":\"Elastic\"' ]",
    command => "sleep 10;curl 'http://${grafanauser}:${grafanapasswd}@${grafanaurl}:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8\' --data-binary \'{\"name\":\"Elastic\",\"type\":\"elasticsearch\",\"url\":\"http://${grafanaurl}:9200\",\"access\":\"proxy\",\"isDefault\":true,\"database\":\"[logstash-]YYY.MM.DD\"'}",
    require => Class[ 'grafana' ],
  }

}
