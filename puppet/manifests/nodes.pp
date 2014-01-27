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

  vps::website { 'wildcard':
    site_config => "puppet:///files/nginx/wildcard",
  }

  # Misc utilities
  package { ["ack-grep", "git", "vim", "curl"]:
    ensure => present,
  }

}
