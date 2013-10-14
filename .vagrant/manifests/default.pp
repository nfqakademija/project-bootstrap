group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

apt::source { 'packages.dotdeb.org':
  location          => 'http://packages.dotdeb.org',
  release           => $lsbdistcodename,
  repos             => 'all',
  required_packages => 'debian-keyring debian-archive-keyring',
  key               => '89DF5277',
  key_server        => 'keys.gnupg.net',
  include_src       => true
}

class { 'puphpet::dotfiles': }

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'wget'
  ]:
  ensure  => 'installed',
}

class { 'nginx': }


nginx::resource::vhost { 'wall.dev':
  ensure       => present,
  server_name  => [
    'wall.dev',
    'www.wall.dev'
  ],
  index_files  => [
    'app_dev.php',
    'app.php',
    'index.php',
    'index.html'
  ],
  listen_port  => 80,
  www_root     => '/var/www/web/',
  try_files    => ['$uri', '$uri/', '/app_dev.php?$args'],
}

$path_translated = 'PATH_TRANSLATED $document_root$fastcgi_path_info'
$script_filename = 'SCRIPT_FILENAME $document_root$fastcgi_script_name'

nginx::resource::location { 'wall.dev-php':
  ensure              => 'present',
  index_files  => [
    'app_dev.php',
    'app.php',
    'index.php',
    'index.html'
  ],
  vhost               => 'wall.dev',
  location            => '~ \.php$',
  proxy               => undef,
  try_files           => ['$uri', '$uri/', '/app.php?$args'],
  www_root            => '/var/www/web/',
  location_cfg_append => {
    'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
    'fastcgi_param'           => 'PATH_INFO $fastcgi_path_info',
    'fastcgi_param '          => $path_translated,
    'fastcgi_param  '         => $script_filename,
    'fastcgi_pass'            => 'unix:/var/run/php5-fpm.sock',
    'fastcgi_index'           => 'app_dev.php',
    'include'                 => 'fastcgi_params'
  },
  notify              => Class['nginx::service'],
}

class { 'php':
  package             => 'php5-fpm',
  service             => 'php5-fpm',
  service_autorestart => false,
  config_file         => '/etc/php5/fpm/php.ini',
  module_prefix       => ''
}

php::module {
  [
    'php5-mysql',
    'php5-cli',
    'php5-curl',
    'php5-intl',
    'php5-gd',
    'php5-mcrypt',
  ]:
  service => 'php5-fpm',
}

service { 'php5-fpm':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => Package['php5-fpm'],
}

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

#prepare pear
exec { "pear auto_discover" :
  command => "/usr/bin/pear config-set auto_discover 1",
  require => [Class['php::pear']]
}
exec { "pear update-channels" :
  command => "/usr/bin/pear update-channels",
  require => [Exec['pear auto_discover']]
}
#install phpunit
exec {"pear install phpunit":
  command => "/usr/bin/pear install --alldeps pear.phpunit.de/PHPUnit",
  creates => '/usr/bin/phpunit',
  require => Exec['pear update-channels']
}
# install phpcs
exec {"pear install phpcs":
  command => "/usr/bin/pear install --alldeps PHP_CodeSniffer",
  creates => '/usr/bin/phpcs',
  require => Exec['pear update-channels']
}


class { 'xdebug':
  service => 'nginx',
}

class { 'composer':
  require => Package['php5-fpm', 'curl'],
}

puphpet::ini { 'xdebug':
  value   => [
    'xdebug.default_enable = 1',
    'xdebug.remote_autostart = 0',
    'xdebug.remote_connect_back = 1',
    'xdebug.remote_enable = 1',
    'xdebug.remote_handler = "dbgp"',
    'xdebug.remote_port = 9000',
    'xdebug.idekey = "PHPSTORM"',
    'xdebug.max_nesting_level = 250'
  ],
  ini     => '/etc/php5/conf.d/custom_xdebug.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'display_errors = On',
    'error_reporting = -1',
    'date.timezone = "Europe/Vilnius"'
  ],
  ini     => '/etc/php5/conf.d/custom_php.ini',
  notify  => Service['php5-fpm'],
  require => Class['php'],
}

class { 'mysql::server':
  config_hash   => { 'root_password' => 'root', 'bind_address' => '0.0.0.0' }
}