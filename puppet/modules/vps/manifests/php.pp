class vps::php {

  package { ["php5-gd", "php5-mysql", "php5-curl"]:
    ensure => present,
    before => Package['php5-fpm'],
  }
  package { 'php5-fpm':
    ensure => present,
  }
  service { 'php5-fpm':
    ensure => running,
    require => Package['php5-fpm'],
  }

}
