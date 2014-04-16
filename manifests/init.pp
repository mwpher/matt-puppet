class matt-puppet {
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
  
  user {
    'matt':
      name   => 'matt',
      home   => '/home/matt',
      managehome => true,
      ensure => present,
      gid => 'matt',
      groups => $rootgroup,
      shell => "${prefix}bin/bash"

  }

  package { tmux: }
  package {
    vim:
      name => $::osfamily ? {
        'FreeBSD' => 'vim-lite'
          default => 'vim'
      },
  }

  vcsrepo {
    '/home/matt/dotfiles':
      provider => git,
      ensure   => present,
      source   => 'git://github.com/mwpher/dotfiles.git',
      user     => 'matt',
      group    => 'matt',
  }

  file {
    '/home/matt/.bashrc':
      ensure => $::osfamily ? {
                   /(.*BSD.*)/ => '/home/matt/dotfiles/FreeBSD/home.bashrc.fbsd'
                   default   => '/home/matt/dotfiles/home.bashrc'
                },
      requires => Vcsrepo['/home/matt/dotfiles'],
      requires => Package['tmux'],
  }
  file {
    'bash.bashrc':
      path => "${path_prefix}etc/bash.bashrc",
      source => '/home/matt/dotfiles/u.l.e.bash.bashrc',
      owner => 'root',
      group => $rootgroup,
      mode => '0755',
      subscribe => Vcsrepo['/home/matt/dotfiles'],
  }
  file {
    '/home/matt/.tmux.conf':
      ensure => '/home/matt/dotfiles/tmux.conf',
      requires => Vcsrepo['/home/matt/dotfiles'],
  }
  file {
    '/home/matt/.vim':
      ensure => '/home/matt/dotfiles/dotvim',
      requires => Package['vim'],
  }
}
