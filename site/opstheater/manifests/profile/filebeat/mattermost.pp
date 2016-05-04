class opstheater::profile::filebeat::mattermost {

  filebeat::prospector { 'mattermostlogs':
    paths    => [
      '/var/log/gitlab/mattermost/current',
      '/var/log/gitlab/mattermost/mattermost.log',
      '/var/log/gitlab/nginx/gitlab_mattermost_access.log',
      '/var/log/gitlab/nginx/gitlab_mattermost_error.log',
    ],
    log_type => 'mattermostlogs-beat',
  }


}

