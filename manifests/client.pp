# Class: ganglia::client
#
# This class installs the ganglia client
#
# Parameters:
#   $cluster
#     default unspecified
#     this is the name of the cluster
#
#   $udp_port
#     default 8649
#     this is the udp port to multicast metrics on
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
#     owner => 'myconpany',
#   }
#
class ganglia::client ($cluster='unspecified', $udp_port='8649', $owner='unspecified',
  $multicast_address = "239.2.11.71",
  $unicast_listen_port = "8649",
  $unicast_targets = [],
  $send_metadata_interval = 0,
  $mode = "unicast",
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
