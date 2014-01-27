class vps::nginx {

  ### Service: nginx ###
  package { 'nginx':
    ensure => present,
  }
  file { 'default-nginx-disable':
    path => '/etc/nginx/sites-enabled/default',
    ensure => absent,
    before => Service['nginx'],
  }
  file { '/srv':
    ensure => directory,
    owner => 'root',
    group => 'root',
    before => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
    require => Package['nginx'],
  }
}
