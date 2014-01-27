node default {

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }
  Package {
    require => Exec['apt-get update']
  }

  include vps::nginx
  include vps::php
  include vps::mysql
  include vps::security

  # Sites
  vps::website { 'wildcard':
    site_config => 'puppet:///files/nginx/wildcard',
  }
  vps::website { 'devkdesigns':
    site_config => 'puppet:///files/nginx/devkdesigns',
    paths => ['/srv/devkdesigns.com', '/srv/devkdesigns.com/www'],
    # TODO: MySQL
  }
  vps::website { 'dump_robhoward':
    site_config => 'puppet:///files/nginx/dump.robhoward.id.au',
    paths => ['/srv/robhoward.id.au/dump'],
  }
  vps::website { 'demo_robhoward':
    site_config => 'puppet:///files/nginx/demo.robhoward.id.au',
    paths => ['/srv/robhoward.id.au/demo'],
  }
  file { '/srv/robhoward.id.au':
    ensure => directory,
    owner => 'www-data',
    group => 'www-data',
    mode => 775,
    before => Vps::Website['demo_robhoward'],
  }

  # Misc utilities
  package { ["ack-grep", "git", "vim", "curl"]:
    ensure => present,
  }

}
