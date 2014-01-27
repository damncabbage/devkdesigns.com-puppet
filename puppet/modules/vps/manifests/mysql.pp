class vps::mysql {

  $root_password = hiera('vps::mysql::root_password')
  if ($root_password) {
    class { 'mysql::server':
      root_password => $root_password,
    }
  } else {
    fail('Missing non-blank Hiera data for vps::mysql::root_password')
  }

  package { ['mysql-client']:
    ensure => present,
  }

}
