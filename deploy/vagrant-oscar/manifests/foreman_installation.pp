class { 'puppetdb': }

class { 'puppetdb::master::config': }

package { [ 'gcc-c++', 'git', 'ruby', 'ruby-devel', 'rubygems', 'libvirt-devel', 'mysql-devel', 'postgresql-devel', 'openssl-devel', 'libxml2-devel', 'sqlite-devel', 'libxslt-devel', 'zlib-devel', 'readline-devel', 'tar', 'augeas-devel', 'screen' ]:
  ensure  => present,
}

vcsrepo { '/opt/foreman':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/theforeman/foreman.git',
  revision => '1.10-stable'
}

vcsrepo { '/opt/smart-proxy':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/theforeman/smart-proxy.git',
  revision => '1.10-stable',
}

postgresql::server::db { 'foreman':
  user     => 'foreman',
  password => 'password',
}

file { '/opt/foreman/config/settings.yaml':
  ensure  => file,
  source  => '/vagrant/files/foreman/settings.yaml',
  require => [ Vcsrepo['/opt/foreman'], Postgresql::Server::Db['foreman'] ],
}

file { '/opt/foreman/config/database.yml':
  ensure  => file,
  source  => '/vagrant/files/foreman/database.yml',
  require => [ Vcsrepo['/opt/foreman'], Postgresql::Server::Db['foreman'] ],
}

file { '/opt/foreman/bundler.d/Gemfile.local.rb':
  ensure  => file,
  content => 'gem "foreman_default_hostgroup", :git => "https://github.com/theforeman/foreman_default_hostgroup.git", :branch => "develop"',
  require => [ Vcsrepo['/opt/foreman'], Postgresql::Server::Db['foreman'] ],
}

file { '/opt/foreman/config/settings.plugins.d':
  ensure  => directory,
  require => [ Vcsrepo['/opt/foreman'], Postgresql::Server::Db['foreman'] ],
}

file { '/opt/foreman/config/settings.plugins.d/default_hostgroup.yaml':
  ensure  => file,
  source  => '/vagrant/files/foreman/default_hostgroup.yaml',
  require => [ Vcsrepo['/opt/foreman'], Postgresql::Server::Db['foreman'] ],
}

file { '/var/log/foreman-proxy':
  ensure  => directory,
}

file { '/opt/smart-proxy/config/settings.yml':
  ensure  => file,
  source  => '/vagrant/files/smart-proxy/settings.yml',
  require => Vcsrepo['/opt/smart-proxy'],
}

file { '/opt/smart-proxy/config/settings.d/puppet.yml':
  ensure  => file,
  source  => '/vagrant/files/smart-proxy/puppet.yml',
  require => Vcsrepo['/opt/smart-proxy'],
}

file { '/opt/smart-proxy/config/settings.d/puppetca.yml':
  ensure  => file,
  source  => '/vagrant/files/smart-proxy/puppetca.yml',
  require => Vcsrepo['/opt/smart-proxy'],
}

file { '/etc/puppetlabs/puppet/foreman.yaml':
  ensure => file,
  source => '/vagrant/files/foreman/foreman.yaml',
}

file { '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/reports/foreman.rb':
  ensure => file,
  source => '/vagrant/files/foreman/foreman.rb',
}

file { '/etc/puppetlabs/puppet/node.rb':
  ensure => file,
  mode   => '0755',
  source => '/vagrant/files/foreman/node.rb',
}

ini_setting { 'set node_terminus':
  ensure  => present,
  path    => '/etc/puppetlabs/puppet/puppet.conf',
  section => 'master',
  setting => 'node_terminus',
  value   => 'exec',
}

ini_setting { 'set external_nodes':
  ensure  => present,
  path    => '/etc/puppetlabs/puppet/puppet.conf',
  section => 'master',
  setting => 'external_nodes',
  value   => '/etc/puppetlabs/puppet/node.rb',
}
