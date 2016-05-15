class opstheater::profile::grafana {
  $grafanauser    = hiera('opstheater::grafana::grafanauser')
  $grafanapasswd  = hiera('opstheater::grafana::grafanapasswd')
  $grafanaurl     = hiera('opstheater::grafana::url')
  $user           = hiera('opstheater::grafana::influxdb::user')
  $password       = hiera('opstheater::grafana::influxdb::password')
  $install_method = hiera('opstheater::profile::grafana::install_method')

  class { '::grafana':
    install_method => $install_method,
  }

  # curl http://admin:admin@localhost:3000/api/datasources -X POST -H 'Content-Type: application/json;charset=UTF-8' \
  # --data '{"Name":"OpsTheater7","type":"elasticsearch","url":"http://elasticsearch.opstheater.vm:9200","access":"proxy","isDefault":true,"database":"[logstash-]YYYY.MM.DD","jsonData":{"timeField":"@timestamp", "esVersion": 2, "interval":"Daily"}}'

  exec { 'elastic_datasource':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => "[ `curl --silent 'http://${grafanauser}:${grafanapasswd}@${grafanaurl}:3000/api/datasources' -X GET | tr ',' '\\n' | grep '\"name\":\"Elastic\"'` == '\"name\":\"Elastic\"' ]",
    command => "sleep 10;curl 'http://${grafanauser}:${grafanapasswd}@${grafanaurl}:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{\"name\":\"Elastic\",\"type\":\"elasticsearch\",\"url\":\"http://${grafanaurl}:9200\",\"access\":\"proxy\",\"isDefault\":true,\"database\":\"[logstash-]YYYY.MM.DD\",\"jsonData\":{\"timeField\":\"@timestamp\", \"esVersion\": 2, \"interval\":\"Daily\"}'}",
    require => Class[ 'grafana' ],
  }

  class { 'influxdb::server' : }

  exec { 'add_influxdb':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => '[ `influx -execute \'SHOW DATABASES\' |grep influxdb` == influxdb ]',
    command => 'sleep 10 && curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE influxdb" && curl -G http://localhost:8086/query --data-urlencode "q=CREATE USER influxadmin WITH PASSWORD \'influxadmin\' WITH ALL PRIVILEGES"',
    require => Class[ 'influxdb::server' ],
  }

  exec { 'influx_datasource':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    unless  => "[ `curl --silent 'http://${grafanauser}:${grafanapasswd}@${grafanaurl}:3000/api/datasources' -X GET | tr ',' '\\n' | grep '\"name\":\"Influx\"'` == '\"name\":\"Influx\"' ]",
    command => "sleep 10;curl 'http://${grafanauser}:${grafanapasswd}@${grafanaurl}:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{\"name\":\"Influx\",\"type\":\"influxdb\",\"url\":\"http://${grafanaurl}:8086\",\"access\":\"proxy\",\"isDefault\":true,\"database\":\"influxdb\",\"user\":\"${user}\",\"password\":\"${password}\"'}",
    require => Class[ 'influxdb::server', 'grafana' ],
  }

}
