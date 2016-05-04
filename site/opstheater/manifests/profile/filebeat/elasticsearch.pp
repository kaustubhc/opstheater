class opstheater::profile::filebeat::elasticsearch {

  filebeat::prospector { 'elasticsearchlogs':
    paths    => [
      '/var/log/elasticsearch/elasticsearch/elasticsearch/elasticsearch.log',
    ],
    log_type => 'elasticlogs-beat',
  }

}
