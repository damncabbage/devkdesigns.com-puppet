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

package { 'mysql-server':
	ensure => present,
}

service { 'mysql':
	ensure => running,
	require => Package['mysql-server'],
}

# Tools and Libraries
$libraries = [ "mysql-client", "php5-gd", "php5-mysql", "php5-curl" ]
package { $libraries: ensure => present }

# Config Files
file { 'devkdesigns-nginx':
	path => '/etc/nginx/sites-available/devkdesigns',
	ensure => file,
	require => Package['nginx'],
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
