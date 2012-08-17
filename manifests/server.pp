# Class: ganglia::server
#
# This class installs the ganglia server
#
# Parameters:
#
#   $gridname
#     default  'unspecified'
#     the name for the grid of clusters
#
#   $clusters
#     default  [ 'my_cluster', ]
#     array of the names of the clusters to publish metrics of
#
# Actions:
#   installs the ganglia server
#
# Sample Usage:
#   include ganglia::server
#
class ganglia::server (
  $gridname = 'unspecified',
  $clusters = [ 'my_cluster', ],
) {

  include concat::setup
  include ganglia::client

  $ganglia_server_pkg = 'gmetad'

  package {$ganglia_server_pkg:
    ensure => present,
    alias  => 'ganglia_server',
  }

  service {$ganglia_server_pkg:
    require => Package[$ganglia_server_pkg];
  }

  concat { '/etc/ganglia/gmetad.conf':
    notify => Service[$ganglia_server_pkg],
  }

  concat::fragment { "gmetad.conf_header":
    order   => 01,
    content => template('ganglia/gmetad.conf.head'),
    target => '/etc/ganglia/gmetad.conf',
  }

  ganglia::data_source { $clusters: }

  concat::fragment { "gmetad.conf_footer":
    order   => 99,
    content => template('ganglia/gmetad.conf.foot'),
    target => '/etc/ganglia/gmetad.conf',
  }

}

