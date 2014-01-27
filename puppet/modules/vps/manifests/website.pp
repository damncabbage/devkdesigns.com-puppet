define vps::website($site_config) {

  file { "/etc/nginx/sites-available/${title}":
    ensure => file,
    require => Package['nginx'],
    notify => Service['nginx'],
    source => $site_config,
  }

  file { "/etc/nginx/sites-enabled/${title}":
    target => "/etc/nginx/sites-available/${title}",
    ensure => link,
    notify => Service['nginx'],
    before => Service['nginx'],
  }

}
