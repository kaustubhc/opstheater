class { 'supervisord':
  install_pip => true,
}

supervisord::program { 'foreman':
  command      => '/opt/foreman/script/rails s -e production',
  directory    => '/opt/foreman',
  autostart    => true,
  autorestart  => true,
  startretries => 2,
  notify       => Exec['waiting for foreman to start up'],
}

supervisord::program { 'smart-proxy':
  command      => '/opt/smart-proxy/bin/smart-proxy',
  directory    => '/opt/smart-proxy',
  autostart    => true,
  autorestart  => true,
  startretries => 2,
  notify       => Exec['waiting for foreman to start up'],
}

exec { 'waiting for foreman to start up':
  command => '/bin/sleep 30',
}
