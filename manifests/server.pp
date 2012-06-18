# Class: ganglia::server
#
# This class installs the ganglia server
#
# Parameters:
#   $cluster
#     default  [{cluster_name => 'my_cluster',[{host => 'localhost', port => 8649}]}]
#     the name of the cluster to publish with metrics
#
# Actions:
#   installs the ganglia server
#
# Sample Usage:
#   include ganglia::server
#
class ganglia::server (
  $clusters = [{cluster_name => 'my_cluster', cluster_hosts => [{address => 'localhost', port => '8649'}]}],
  $gridname = '',
  ) {

  include ganglia::client

  $ganglia_server_pkg = 'gmetad'

  package {$ganglia_server_pkg:
    ensure => present,
    alias  => 'ganglia_server',
  }

  service {$ganglia_server_pkg:
    require => Package[$ganglia_server_pkg];
  }

  file {'/etc/ganglia/gmetad.conf':
    ensure  => present,
    require => Package['ganglia_server'],
    notify  => Service[$ganglia_server_pkg],
    content => template('ganglia/gmetad.conf');
  }

}
