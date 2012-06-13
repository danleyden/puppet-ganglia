# Class: ganglia::client
#
# This class installs the ganglia client
#
# Parameters:
#   $cluster
#     default unspecified
#     this is the name of the cluster
#
#   $multicast_address
#     default 239.2.11.71
#     this is the multicast address to publish metrics on
#
#   $owner
#     default unspecified
#     the owner of the cluster
#
#   $send_metadata_interval
#     default 0
#     the interval (seconds) at which to resend metric metadata.
#     If running unicast, this should not be 0
#
#   $udp_port
#     default 8649
#     this is the udp port to multicast metrics on
#
#   $unicast_listen_port
#     default 8649
#     the port to listen for unicast metrics on
#
#   $unicast_targets
#     default []
#     an array of servers to send unicast metrics to.
#     each entry in the array should be a hash containing an entry named
#     ipaddress and an entry named port
#     e.g. [ {'ipaddress' => '1.2.3.4', 'port' => '1234'} ]
#
# Actions:
#   installs the ganglia client
#
# Sample Usage:
#   include ganglia::client
#
#   or
#
#   class {'ganglia::client': cluster => 'mycluster' }
#
#   or
#
#   class {'ganglia::client':
#     cluster  => 'mycluster',
#     udp_port => '1234',
#     owner    => 'mycompany',
#   }
#
class ganglia::client (
  $cluster='unspecified',
  $multicast_address = '239.2.11.71',
  $owner='unspecified',
  $send_metadata_interval = 0,
  $udp_port='8649',
  $unicast_listen_port = '8649',
  $unicast_targets = []
  ) {

  case $operatingsystem {
    'Ubuntu': {$ganglia_client_pkg = 'ganglia-monitor'}
    'CentOS': {$ganglia_client_pkg = 'ganglia-gmond'}
    default:  {fail('no known ganglia monitor package for this OS')}
  }

  package {$ganglia_client_pkg:
    ensure => 'installed',
    alias  => 'ganglia_client',
  }

  service {'ganglia-monitor':
    require => Package[$ganglia_client_pkg];
  }

  file {'/etc/ganglia/gmond.conf':
    ensure  => present,
    require => Package['ganglia_client'],
    content => template('ganglia/gmond.conf'),
    notify  => Service['ganglia-monitor'];
  }

}
