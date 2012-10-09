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
#   $network_mode
#     default multicast
#     multicast or unicast
#
#   $user
#     default ganglia
#     The user account to be used by the ganglia service
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
  $ensure = 'installed',
  $cluster='unspecified',
  $multicast_address = '239.2.11.71',
  $owner='unspecified',
  $send_metadata_interval = 0,
  $udp_port = '8649',
  $unicast_listen_port = '8649',
  $unicast_targets = [],
  $network_mode ='multicast',
  $user = 'ganglia',
  ) {

  case $::osfamily {
    'Debian': {
      $ganglia_client_pkg     = 'ganglia-monitor'
      $ganglia_client_service = 'ganglia-monitor'
      $ganglia_lib_dir        = '/usr/lib/ganglia'
      Service[$ganglia_client_service] {
        hasstatus => false,
        status    => "ps -ef | grep gmond | grep ${user} | grep -qv grep"
      }
    }
    'RedHat': {
      # requires epel repo
      $ganglia_client_pkg     = 'ganglia-gmond'
      $ganglia_client_service = 'gmond'
      $ganglia_lib_dir        = $::architecture ? {
        /(amd64|x86_64)/ => '/usr/lib64/ganglia',
        default          => '/usr/lib/ganglia',
      }
    }
    default:  {fail('no known ganglia monitor package for this OS')}
  }

  package {$ganglia_client_pkg:
    ensure => $ensure,
    alias  => 'ganglia_client',
  }

  service {$ganglia_client_service:
    ensure  => 'running',
    alias   => 'ganglia_client',
    require => Package[$ganglia_client_pkg];
  }

  file {'/etc/ganglia/gmond.conf':
    ensure  => present,
    require => Package['ganglia_client'],
    content => template('ganglia/gmond.conf'),
    notify  => Service[$ganglia_client_service];
  }
}
