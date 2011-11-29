# Class: ganglia::server
#
# This class installs the ganglia server
#
# Parameters:
#
# Actions:
#   installs the ganglia server
#
# Sample Usage:
#   include ganglia::server
#
class ganglia::server {

  include ganglia::client

  $ganglia_server_pkg = 'gmetad'

  package {$ganglia_server_pkg:
    ensure => present,
    alias  => 'ganglia_server',
  }

  service {$ganglia_server_pkg:
    ensure  => 'running',
    require => Package[$ganglia_server_pkg];
  }

  file {'/etc/ganglia/gmetad.conf':
    ensure  => present,
    require => Package['ganglia_server'],
    notify  => Service[$ganglia_server_pkg],
    content => template('ganglia/gmetad.conf');
  }

}
