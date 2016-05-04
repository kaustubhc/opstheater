class opstheater::profile::base::apt {
  # include base aptitude class
  include ::apt

  # get keys from hiera and create them
  $keys = hiera_hash('opstheater::profile::base::apt::keys', undef)
  if $keys {
    create_resources('apt::key', $keys)
  }

  # get repos from hiera and create them
  $repositories = hiera_hash('opstheater::profile::base::apt::repositories', undef)
  if $repositories {
    create_resources('apt::source', $repositories)
  }
}