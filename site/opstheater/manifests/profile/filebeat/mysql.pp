class opstheater::profile::filebeat::mysql {

  filebeat::prospector { 'mysqllogs':
    paths    => [
      '/var/log/mariadb/mariadb.log',
      '/var/log/mysql/mysqld.log',
      '/var/log/mysql/mysqld.err',
      '/var/log/mysql/error.log',
      '/var/log/mysqld.log',
    ],
    log_type => 'mysqllogs-beat',
  }

}

