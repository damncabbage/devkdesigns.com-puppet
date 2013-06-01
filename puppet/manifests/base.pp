import './_credentials.pp'

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
$extras = [ "ack-grep", "git", "vim", "mysql-client", "php5-gd", "php5-mysql", "php5-curl" ]
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


### Sites ###

file { '/srv':
  ensure => directory,
  owner => 'root',
  group => 'root',
}

# Disable default
file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

# Enable wildcard
file { 'wildcard-nginx':
	path => '/etc/nginx/sites-available/wildcard',
	ensure => file,
	require => [ Package['nginx'] ],
	source => 'puppet:///modules/nginx/wildcard',
}

file { 'wildcard-nginx-enable':
	path => '/etc/nginx/sites-enabled/wildcard',
	target => '/etc/nginx/sites-available/wildcard',
	ensure => link,
	notify => Service['nginx'],
	require => [ File['default-nginx-disable'] ],
}


# devkdesigns
file {
  ['/srv/devkdesigns.com',
   '/srv/devkdesigns.com/www']:
  ensure => directory,
  owner => 'www-data',
  group => 'www-data',
  mode => 775,
}

file { 'devkdesigns-nginx':
	path => '/etc/nginx/sites-available/devkdesigns',
	ensure => file,
	require => [ File['/srv/devkdesigns.com/www'], Package['nginx'] ],
	source => 'puppet:///modules/nginx/devkdesigns',
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

# robhoward.id.au
file {
  ['/srv/robhoward.id.au',
   '/srv/robhoward.id.au/dump',
   '/srv/robhoward.id.au/demo']:
  ensure => directory,
  owner => 'www-data',
  group => 'www-data',
  mode => 775,
}

file { 'dump-robhoward-nginx':
	path => '/etc/nginx/sites-available/dump.robhoward.id.au',
	ensure => file,
	require => [ File['/srv/robhoward.id.au/dump'], Package['nginx'] ],
	source => 'puppet:///modules/nginx/dump.robhoward.id.au',
}

file { 'dump-robhoward-nginx-enable':
	path => '/etc/nginx/sites-enabled/dump.robhoward.id.au',
	target => '/etc/nginx/sites-available/dump.robhoward.id.au',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['dump-robhoward-nginx'],
		File['default-nginx-disable'],
	],
}

file { 'demo-robhoward-nginx':
	path => '/etc/nginx/sites-available/demo.robhoward.id.au',
	ensure => file,
	require => [ File['/srv/robhoward.id.au/demo'], Package['nginx'] ],
	source => 'puppet:///modules/nginx/demo.robhoward.id.au',
}

file { 'demo-robhoward-nginx-enable':
	path => '/etc/nginx/sites-enabled/demo.robhoward.id.au',
	target => '/etc/nginx/sites-available/demo.robhoward.id.au',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['demo-robhoward-nginx'],
		File['default-nginx-disable'],
	],
}
