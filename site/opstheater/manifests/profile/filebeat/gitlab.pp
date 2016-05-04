class opstheater::profile::filebeat::gitlab {

  filebeat::prospector { 'gitlablogs':
    paths    => [
      '/var/log/gitlab/nginx/gitlab_access.log',
      '/var/log/gitlab/nginx/gitlab_error.log',
      '/var/log/gitlab/nginx/gitlab_ci_access.log',
      '/var/log/gitlab/nginx/gitlab_ci_error.log',
      '/var/log/gitlab/gitlab-rails/production.log',
      '/var/log/gitlab/unicorn/unicorn_stdout.log',
      '/var/log/gitlab/unicorn/unicorn_stderr.log',
    ],
    log_type => 'gitlablogs-beat',
  }

}

