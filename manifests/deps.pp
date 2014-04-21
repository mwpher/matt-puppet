class matt-puppet::deps {
  Package { ensure => installed, }
  
  $path_prefix = $osfamily ? {
    FreeBSD => '/usr/local/',
    default => '/',
  }

  $rootgroup = $osfamily ? {
    'Solaris'          => 'wheel',
    /(Darwin|.*BSD.*)/ => 'wheel',
    default            => 'root',
  }
  
  package {  'tmux': }
  package {  'bash': }
  package {
    'vim':
      name => $::osfamily ? {
        'FreeBSD' => 'vim-lite',
          default => 'vim',
      },
  }
  
  file {
    'bash.bashrc':
      path => "${path_prefix}etc/bash.bashrc",
      source => 'puppet:///modules/matt-puppet/u.l.e.bash.bashrc',
      owner => 'root',
      group => $rootgroup,
      mode => '0755',
  }

  Package['bash'] -> File['bash.bashrc']
}
