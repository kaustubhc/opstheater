class opstheater::role::monitoring::standalone {
  include opstheater::profile::base
  include opstheater::profile::icinga::web
  include opstheater::profile::icinga::server
  include opstheater::profile::icinga::checks
}
