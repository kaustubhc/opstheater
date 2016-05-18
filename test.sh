#!/bin/bash

PWD=`pwd`

#echo Enter domain name Eg: `hostname -d`:
#read DOMAINNAME
DOMAINNAME=adobe.vm
#echo Enter Puppet Servername:
#read PUPPETSERVERNAME
PUPPETSERVERNAME=puppet
#echo Enter GitLab Servername:
#read GITSERVER
#echo Enter GitLab IP address:
#read GITSERVERIP
GITSERVER=adobegit
GITSERVERIP=10.10.10.1
#echo Enter Icinga2 Servername:
#read ICINGA
#echo Enter Icinga2 IP address:
#read ICINGAIP
ICINGA=monitoring
ICINGAIP=10.10.10.2
#echo Enter ELK Servername:
#read ELK
#echo Enter ELK IP address:
#read ELKIP
ELK=elkstack
ELKIP=10.10.10.3
#echo Enter MySQL Servername:
#read MYSQL
#echo Enter MySQL IP address:
#read MYSQLIP
#echo Enter MySQL White List Range Generally this is same n/w range of the mysql server ip eg: 10.20.1:
#read MYSQLWLR
MYSQL=adobedb
MYSQLIP=10.10.10.4
MYSQLWLR=10.10.10


#echo Enter Admin Email:
#read MAILADMIN
#echo Enter SMTP User:
#read SMTPUSER
#echo Enter SMTP Passwd:
#read SMTPPWD
MAILADMIN=admin
SMTPUSER=myadmin@adobe.vm
SMTPPWD=123


echo Enter Opstheater mode http or https:
read MODE

#echo "Updating Hiera Data for MySQL ELK and Git.

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
echo "'opstheater::domain': '"$DOMAINNAME"'" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::admin_email\': \""$MAILADMIN"@%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::http_mode': '$MODE'" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::fqdn': 'localhost'" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::port': 587" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::ssl_type': 'none'" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::auth_type': 'login'" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::openssl_verify_mode': 'none'" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::username': '"$SMTPUSER"'" >> $PWD/hieradata/60.opstheater.yaml
echo "'opstheater::smtp::password': '"$SMTPPWD"'" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::foreman::fqdn\': \""$PUPPETSERVERNAME".%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::foreman::url\': \""%{hiera('opstheater::http_mode')}://%{hiera('opstheater::foreman::fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icinga::fqdn\': \""$ICINGA".%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icinga::ipaddress\': \'"$ICINGAIP"\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icinga::mysql_fqdn\': \""%{hiera('opstheater::mysql::fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icinga::mysql_ipaddress\': \""%{hiera('opstheater::mysql::ipaddress')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icinga::ido_password\': '"password"' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::fqdn\': \""%{hiera('opstheater::icinga::fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::ipaddress\': \""%{hiera('opstheater::icinga::ipaddress')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::mysql_fqdn\': \""%{hiera('opstheater::icinga::mysql_fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::mysql_ipaddress\': \""%{hiera('opstheater::icinga::mysql_ipaddress')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::icingaweb::webdb_password\': '"password"' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::elasticsearch::fqdn\': \""$ELK".%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::elasticsearch::ipaddress\': \'"$ELKIP"\' >> $PWD/hieradata/60.opstheater.yaml >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::kibana::fqdn\': \""%{hiera('opstheater::elasticsearch::fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::kibana::ipaddress\': \""%{hiera('opstheater::elasticsearch::ipaddress')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::logstash::fqdn\': \""%{hiera('opstheater::elasticsearch::fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::logstash::ipaddress\': \""%{hiera('opstheater::elasticsearch::ipaddress')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::gitlab::fqdn\': \""$GITSERVER".%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::gitlab::ipaddress\': \'"$GITSERVERIP"\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::mattermost::fqdn\': \"chat.%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::mattermost::url\': \""%{hiera('opstheater::http_mode')}://chat.%{hiera('opstheater::domain')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::mattermost::ipaddress\': \""%{hiera('opstheater::gitlab::ipaddress')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::mysql::fqdn\': \""$MYSQL".%{hiera\(\'opstheater::domain\'\)}\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::mysql::ipaddress\': \'"$MYSQLIP"\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::mysql::whitelist_range\': \'"$MYSQLWLR".%\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::grafana::grafanauser\': \'admin\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::grafana::grafanapasswd\': \'admin\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::grafana::url\': \""%{hiera('opstheater::elasticsearch::fqdn')}"\" >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::grafana::influxdb::user\': \'admin\' >> $PWD/hieradata/60.opstheater.yaml
echo \'opstheater::grafana::influxdb::password\': \'admin\' >> $PWD/hieradata/60.opstheater.yaml
