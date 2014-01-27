class vps::security {

  package { 'fail2ban':
    ensure => present,
  }
  service { 'fail2ban':
    ensure => running,
    require => Package['fail2ban'],
  }

}
