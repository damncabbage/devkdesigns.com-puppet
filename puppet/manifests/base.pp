$passwd_mysql_root        = "CHANGEME"
$passwd_mysql_devkdesigns = "CHANGEME"


group { 'puppet':
	ensure => present,
}

exec { 'apt-get update':
	command => '/usr/bin/apt-get update',
}

Package { require => Exec['apt-get update'] }


# Services
package { 'nginx':
	ensure => present,
}

service { 'nginx':
	ensure => running,
	require => Package['nginx'],
}

package { 'php5-fpm':
	ensure => present,
}

service { 'php5-fpm':
	ensure => running,
	require => Package['php5-fpm'],
}

package { 'fail2ban':
  ensure => present,
}

service { 'fail2ban':
  ensure => running,
  require => Package['fail2ban'],
}


# Tools and Libraries
$extras = [ "git", "vim", "mysql-client", "php5-gd", "php5-mysql", "php5-curl" ]
package { $extras: ensure => present }


# Databases
class { 'mysql::server':
  config_hash => {
    'root_password' => $passwd_mysql_root,
  }
}

mysql::db { 'devkdesigns':
  user      => 'devkdesigns',
  password  => $passwd_mysql_devkdesigns,
  host      => 'localhost',
  grant     => ['all'],
}

# Config Files
file {
  ['/srv',
   '/srv/devkdesigns.com',
   '/srv/devkdesigns.com/www']:
  ensure => directory,
  owner => 'www-data',
  group => 'www-data',
}

file { 'devkdesigns-nginx':
	path => '/etc/nginx/sites-available/devkdesigns',
	ensure => file,
	require => [ File['/srv/devkdesigns.com/www'], Package['nginx'] ],
	source => 'puppet:///modules/nginx/devkdesigns',
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

file { 'devkdesigns-nginx-enable':
	path => '/etc/nginx/sites-enabled/devkdesigns',
	target => '/etc/nginx/sites-available/devkdesigns',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['devkdesigns-nginx'],
		File['default-nginx-disable'],
	],
}
