class matt-puppet::root inherits matt-puppet::deps {
  user {
    'root':
      name   => 'root',
      home   => '/root',
      managehome => true,
      ensure => present,
      gid => $rootgroup,
      shell => "${path_prefix}bin/bash",
      require => Package['bash'],
  }

  vcsrepo {
    '/root/dotfiles':
      provider => git,
      ensure   => present,
      source   => 'git://github.com/mwpher/dotfiles.git',
      user     => 'root',
      group    => $rootgroup,
  }

  file {
    '/root/.bashrc':
      ensure => $::osfamily ? {
                   /(.*BSD.*)/ => '/root/dotfiles/FreeBSD/home.bashrc.fbsd',
                   default   => '/root/dotfiles/home.bashrc',
                },
      require => [ Vcsrepo['/root/dotfiles'],
                    Package['bash'],
                    Package['tmux'] ],
  }
  file {
    '/root/.tmux.conf':
      ensure => '/root/dotfiles/tmux.conf',
      require => [ Vcsrepo['/root/dotfiles'],
                    Package['tmux'] ],
  }
  file {
    '/root/.vim':
      ensure => '/root/dotfiles/dotvim',
      require => Package['vim'],
  }
  
  # ``Package['vim', 'bash', 'tmux'] -> Vcsrepo['/root/dotfiles'] -> File['/root/.tmux.conf', '/root/.vim']
}

