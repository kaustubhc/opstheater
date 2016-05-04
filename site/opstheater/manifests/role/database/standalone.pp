class opstheater::role::database::standalone {
  include opstheater::profile::base
  include opstheater::profile::mysql
  include opstheater::profile::icinga::db
}
