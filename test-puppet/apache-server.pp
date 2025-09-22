class apache_server {
  package { 'httpd':
    ensure => installed,
  }

  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => Package['httpd'],
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => '<h1>Welcome to Apache</h1>',
    require => Package['httpd'],
  }

  firewall { '100 allow http':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }

  user { 'webuser':
    ensure     => present,
    home       => '/home/webuser',
    managehome => true,
    password   => 'changeme123',
  }
}