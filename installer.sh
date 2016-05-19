#!/bin/bash


echo Enter domain name:
read DOMAINNAME

echo Enter Puppet Servername:
read PUPPETSERVERNAME

FQDN="$PUPPETSERVERNAME"."$DOMAINNAME"

echo Enter GitLab Servername:
read GITSERVER
echo Enter GitLab IP address:
read GITSERVERIP

echo Enter Icinga2 Servername:
read ICINGA
echo Enter Icinga2 IP address:
read ICINGAIP

echo Enter ELK Servername:
read ELK
echo Enter ELK IP address:
read ELKIP

echo Enter MySQL Servername:
read MYSQL
echo Enter MySQL IP address:
read MYSQLIP
echo Enter MySQL White List Range Generally this is same n/w range of the mysql server ip eg: 10.20.1:
read MYSQLWLR

echo Enter Admin Email:
read MAILADMIN
echo Enter SMTP User:
read SMTPUSER
echo Enter SMTP Passwd:
read SMTPPWD

echo Enter Opstheater mode http or https:
read MODE

mv hieradata/10.fqdn/elasticsearch.opstheater.vm.yaml hieradata/10.fqdn/"$ELK"."$DOMAINNAME".yaml
mv hieradata/10.fqdn/gitlab.opstheater.vm.yaml hieradata/10.fqdn/"$GITSERVER"."$DOMAINNAME".yaml
mv hieradata/10.fqdn/mysql.opstheater.vm.yaml hieradata/10.fqdn/"$MYSQL"."$DOMAINNAME".yaml

sed "s/master.opstheater.vm/$HOSTNAME/" installer/files/foreman/settings.yaml > installer/files/foreman/settings.yaml.tmp
mv -f installer/files/foreman/settings.yaml.tmp installer/files/foreman/settings.yaml
sed "s/opstheater.vm/$DOMAINNAME/" installer/files/foreman/settings.yaml > installer/files/foreman/settings.yaml.tmp
mv -f installer/files/foreman/settings.yaml.tmp installer/files/foreman/settings.yaml


sed "s/master.opstheater.vm/$HOSTNAME/g" installer/files/foreman/foreman.yaml > installer/files/foreman/foreman.yaml.tmp
mv -f installer/files/foreman/foreman.yaml.tmp installer/files/foreman/foreman.yaml

sed "s/master.opstheater.vm/$HOSTNAME/g" installer/files/smart-proxy/puppet.yml > installer/files/smart-proxy/puppet.yml.tmp
mv -f installer/files/smart-proxy/puppet.yml.tmp installer/files/smart-proxy/puppet.yml

sed "s/master.opstheater.vm/$HOSTNAME/g" installer/files/smart-proxy/settings.yml > installer/files/smart-proxy/settings.yml.tmp
mv -f installer/files/smart-proxy/settings.yml.tmp installer/files/smart-proxy/settings.yml


echo '---' > hieradata/60.opstheater.yaml
echo "'opstheater::domain': '"$DOMAINNAME"'" >> hieradata/60.opstheater.yaml
echo \'opstheater::admin_email\': \""$MAILADMIN"@%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo "'opstheater::http_mode': '$MODE'" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::fqdn': 'localhost'" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::port': 587" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::ssl_type': 'none'" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::auth_type': 'login'" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::openssl_verify_mode': 'none'" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::username': '"$SMTPUSER"'" >> hieradata/60.opstheater.yaml
echo "'opstheater::smtp::password': '"$SMTPPWD"'" >> hieradata/60.opstheater.yaml
echo \'opstheater::foreman::fqdn\': \""$PUPPETSERVERNAME".%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo \'opstheater::foreman::url\': \""%{hiera('opstheater::http_mode')}://%{hiera('opstheater::foreman::fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icinga::fqdn\': \""$ICINGA".%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icinga::ipaddress\': \'"$ICINGAIP"\' >> hieradata/60.opstheater.yaml
echo \'opstheater::icinga::mysql_fqdn\': \""%{hiera('opstheater::mysql::fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icinga::mysql_ipaddress\': \""%{hiera('opstheater::mysql::ipaddress')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icinga::ido_password\': '"password"' >> hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::fqdn\': \""%{hiera('opstheater::icinga::fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::ipaddress\': \""%{hiera('opstheater::icinga::ipaddress')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::mysql_fqdn\': \""%{hiera('opstheater::icinga::mysql_fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::mysql_ipaddress\': \""%{hiera('opstheater::icinga::mysql_ipaddress')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::webdb_password\': '"password"' >> hieradata/60.opstheater.yaml
echo \'opstheater::elasticsearch::fqdn\': \""$ELK".%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo \'opstheater::elasticsearch::ipaddress\': \'"$ELKIP"\' >> hieradata/60.opstheater.yaml
echo \'opstheater::kibana::fqdn\': \""%{hiera('opstheater::elasticsearch::fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::kibana::ipaddress\': \""%{hiera('opstheater::elasticsearch::ipaddress')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::logstash::fqdn\': \""%{hiera('opstheater::elasticsearch::fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::logstash::ipaddress\': \""%{hiera('opstheater::elasticsearch::ipaddress')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::gitlab::fqdn\': \""$GITSERVER".%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo \'opstheater::gitlab::ipaddress\': \'"$GITSERVERIP"\' >> hieradata/60.opstheater.yaml
echo \'opstheater::mattermost::fqdn\': \"chat.%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo \'opstheater::mattermost::url\': \""%{hiera('opstheater::http_mode')}://chat.%{hiera('opstheater::domain')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::mattermost::ipaddress\': \""%{hiera('opstheater::gitlab::ipaddress')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::mysql::fqdn\': \""$MYSQL".%{hiera\(\'opstheater::domain\'\)}\" >> hieradata/60.opstheater.yaml
echo \'opstheater::mysql::ipaddress\': \'"$MYSQLIP"\' >> hieradata/60.opstheater.yaml
echo \'opstheater::mysql::whitelist_range\': \'"$MYSQLWLR".%\' >> hieradata/60.opstheater.yaml
echo \'opstheater::grafana::grafanauser\': \'admin\' >> hieradata/60.opstheater.yaml
echo \'opstheater::grafana::grafanapasswd\': \'admin\' >> hieradata/60.opstheater.yaml
echo \'opstheater::grafana::url\': \""%{hiera('opstheater::elasticsearch::fqdn')}"\" >> hieradata/60.opstheater.yaml
echo \'opstheater::grafana::influxdb::user\': \'admin\' >> hieradata/60.opstheater.yaml
echo \'opstheater::grafana::influxdb::password\': \'admin\' >> hieradata/60.opstheater.yaml



/bin/echo '==> Disabling firewall'
/bin/systemctl stop firewalld
/bin/systemctl disable firewalld
/bin/yum install -y -q https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm epel-release
/bin/yum install -y -q puppetserver
/opt/puppetlabs/bin/puppet module install puppetlabs/puppetdb --version 5.1.2
/opt/puppetlabs/bin/puppet module install puppetlabs/vcsrepo --version 1.3.2
/opt/puppetlabs/bin/puppet module install zack/r10k --version 3.2.0
/opt/puppetlabs/bin/puppet module install abrader/gms --version 1.0.2
/opt/puppetlabs/bin/puppet module install ajcrowe/supervisord --ignore-dependencies --version 0.6.0
/bin/echo '==> Set puppetserver hostname'
/opt/puppetlabs/bin/puppet apply -e 'ini_setting { "set master hostname": ensure => present, section => "main", value => $::fqdn, path => "/etc/puppetlabs/puppet/puppet.conf", setting => "server" }'
/bin/echo '==> Set puppetserver autosign'
/opt/puppetlabs/bin/puppet apply -e 'file { "/etc/puppetlabs/puppet/autosign.conf": ensure => file, content => "$::fqdn\n*\n", }'
/bin/touch /etc/puppetlabs/code/environments/production/manifests/site.pp
/opt/puppetlabs/bin/puppet resource service puppetserver enable=true
/bin/systemctl start puppetserver
/bin/echo '==> Install + configure foreman and smart proxy'
/opt/puppetlabs/bin/puppet apply /opt/opstheater/installer/manifests/foreman_installation.pp
/opt/puppetlabs/bin/puppet apply -e 'ini_setting { "set foreman report ": ensure => present, section => "main", value => "log,foreman", path => "/etc/puppetlabs/puppet/puppet.conf", setting => "reports" }'
/usr/bin/gem install bundler --no-ri --quiet --no-verbose
/bin/echo '==> /usr/local/bin/bundle install --without mysql2 sqlite test --path vendor'
cd /opt/foreman; /usr/local/bin/bundle install --without mysql2 sqlite test --path vendor --quiet
/bin/echo '==> /usr/local/bin/bundle update foreman_default_hostgroup'
cd /opt/foreman; /usr/local/bin/bundle update foreman_default_hostgroup
/bin/echo '==> RAILS_ENV=production bundle exec rake db:migrate'
RAILS_ENV=production bundle exec rake db:migrate --quiet
/bin/echo '==> RAILS_ENV=production bundle exec rake assets:precompile locale:pack apipie:cache'
RAILS_ENV=production bundle exec rake assets:precompile locale:pack apipie:cache --quiet
/bin/echo '==> RAILS_ENV=production bundle exec rake db:seed'
CREDENTIALS=`RAILS_ENV=production bundle exec rake db:seed --quiet | grep "Login"`
/bin/echo '==> /usr/local/bin/bundle install --without development test --path vendor --quiet'
cd /opt/smart-proxy; /usr/local/bin/bundle install --without development test --path vendor --quiet
cd /opt/smart-proxy; /usr/local/bin/bundle update rubocop
/bin/echo '==> Configure supervisord for foreman and smart-proxy'
/opt/puppetlabs/bin/puppet apply /opt/opstheater/installer/manifests/foreman_post_install.pp
PASSWD=`/bin/echo $CREDENTIALS | awk ' { print $NF } '`
/bin/echo '==> Clear iptables rules'
/sbin/iptables -F
/bin/echo '==> Add new smart proxy to Foreman'
/bin/sleep 20
/bin/curl -k -s -u admin:$PASSWD -H "Accept: version=2,application/json" -H "Content-Type: application/json" -X POST -d "{ \"name\": \"foreman\", \"url\": \"https://"${FQDN:8443}" }"  http://$FQDN:3000/api/smart_proxies
/bin/echo '==> Import all puppet classes and environments to Foreman'
/bin/curl -k -s -u admin:$PASSWD -H "Accept: version=2,application/json" -H "Content-Type: application/json" -X POST -d '{ }' http://$FQDN:3000/api/smart_proxies/1/import_puppetclasses
/bin/echo '==> Create OpsTheater hostgroup'
/bin/curl -k -s -u admin:$PASSWD -H "Accept: version=2,application/json" -H "Content-Type: application/json" -X POST -d '{ "name": "OpsTheater Infra", "environment_id": "1", "puppet_ca_proxy_id": "1", "puppet_proxy_id": "1" } ' http://$FQDN:3000/api/hostgroups
/bin/echo '==> /bin/systemctl restart puppetserver'
/bin/systemctl restart puppetserver
/bin/echo '==> Setup R10K'
/opt/puppetlabs/bin/puppet apply /opt/opstheater/installer/manifests/r10k_installation.pp
/opt/puppetlabs/puppet/bin/r10k deploy environment -pv
/bin/echo '==> puppet config set hiera_config /etc/puppetlabs/code/environments/production/hiera.yaml'
/opt/puppetlabs/bin/puppet config set hiera_config /etc/puppetlabs/code/environments/production/hiera.yaml
/bin/echo '==> /bin/systemctl restart puppetserver'
/bin/systemctl restart puppetserver
/bin/echo '==> Update Foreman puppet environments'
/bin/curl -k -s -u admin:$PASSWD -H "Accept: version=2,application/json" -H "Content-Type: application/json" -X POST -d '{ }' http://$FQDN:3000/api/smart_proxies/1/import_puppetclasses
/bin/echo '==> /opt/puppetlabs/bin/puppet agent -t'
/opt/puppetlabs/bin/puppet agent -t || true
/bin/systemctl stop puppet
/bin/echo "==> Foreman URL: http://$FQDN:3000"
/bin/echo "==> $CREDENTIALS"
