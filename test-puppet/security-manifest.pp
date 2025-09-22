class security_issues {
  # Hard-coded password
  $db_password = 'hardcoded123'
  $api_secret = 'sk-abcdef1234567890'

  # Create user with weak password
  user { 'admin':
    ensure   => present,
    password => 'admin',
    shell    => '/bin/bash',
  }

  # Weak crypto usage
  exec { 'generate_hash':
    command => '/usr/bin/echo "password" | /usr/bin/md5sum',
    path    => ['/usr/bin', '/bin'],
  }

  # HTTP without TLS
  exec { 'download_file':
    command => '/usr/bin/wget http://example.com/script.sh -O /tmp/script.sh',
    path    => ['/usr/bin', '/bin'],
  }

  # Invalid IP binding
  file { '/etc/myapp/config':
    ensure  => file,
    content => "bind_address: 0.0.0.0\npassword: secret123\n",
  }
}