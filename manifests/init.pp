class matt-puppet inherits matt-puppet::deps {
  user {
    'matt':
      name   => 'matt',
      home   => '/home/matt',
      managehome => true,
      ensure => present,
      gid => 'matt',
      groups => $rootgroup,
      shell => "${path_prefix}bin/bash",
      require => Package['bash'],
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
                   /(.*BSD.*)/ => '/home/matt/dotfiles/FreeBSD/home.bashrc.fbsd',
                   default   => '/home/matt/dotfiles/home.bashrc',
                },
      require => [ Vcsrepo['/home/matt/dotfiles'],
                    Package['bash'],
                    Package['tmux'] ],
  }
  file {
    '/home/matt/.tmux.conf':
      ensure => '/home/matt/dotfiles/tmux.conf',
      require => [ Vcsrepo['/home/matt/dotfiles'], 
                    Package['tmux'] ],
  }
  file {
    '/home/matt/.vim':
      ensure => '/home/matt/dotfiles/dotvim',
      require => Package['vim'],
  }

  # Package['vim', 'bash', 'tmux'] -> Vcsrepo['/home/matt/dotfiles'] -> File['/home/matt/.tmux.conf', '/home/matt/.vim']
}
