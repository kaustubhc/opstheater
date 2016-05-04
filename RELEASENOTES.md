# Release notes

## Release 1.6 ( May 2nd 2016)

This is a Major Milestone Release of Opstheater. We go OpenSource with 1.6

Yes Opstheater is now OpenSource.


In this release the number of changes is limited as most of the capacity in this sprint was used to make internal changes to the project infrastructure.
The following has been added along the way:
* Logstash filters for filtering access logs of following components:
  * Puppetmaster
  * PupptDB
  * Gitlab
  * Mattermost
* Used Puppet Lint to make sure that all our puppet code is following Puppetlabs style guide and we pass an initial CI build on each push to gitlab

Tech Preview
* Grafana & InfluxDB - graph and dashboard builder for visualizing time series metrics


In addition to this, we have updated the components in use by OpsTheater to the following versions, each of which comes with it's own release notes:

| Tool | Version | Release notes |
|--- | --- | --- |
| Foreman | 1.10.3 | [Release notes](http://theforeman.org/manuals/1.10/index.html#Releasenotesfor1.10.3) |
| FOSS Puppet | 4.4.2 | [Release notes](https://docs.puppet.com/puppet/4.4/reference/release_notes.html#puppet-442) |
| Percona Server | 5.6.29 | [Release notes](https://www.percona.com/doc/percona-server/5.6/release-notes/Percona-Server-5.6.29-76.2.html) |
| Icinga Web 2 | 2.2.3 | [Release notes](https://github.com/Icinga/icingaweb2/blob/master/ChangeLog) |
| Icinga 2 | 2.4.7 | [Release notes](https://www.icinga.org/2016/04/21/icinga-2-v2-4-7-bugfix-release/) |
| Gitlab | 8.7 | [Release notes](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/CHANGELOG) |
| Mattermost | 2.2 | [Release notes](https://github.com/mattermost/platform/releases/tag/v2.2.0) |
| ElasticSearch | 2.3.2 | [Release notes](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/release-notes-2.3.2.html) |
| Logstash | 2.1.1 | [Release notes](https://github.com/elastic/logstash/blob/2.1/CHANGELOG.md) |
| Kibana | 4.2.1 | [Release notes](https://www.elastic.co/guide/en/kibana/4.2/releasenotes.html) |
| Filebeat | 1.2.2 | [Release notes](https://www.elastic.co/guide/en/beats/libbeat/current/release-notes-1.2.2.html) |
