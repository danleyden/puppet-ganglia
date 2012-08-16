# Class: ganglia::server
#
# This class installs the ganglia server
#
# Parameters:
#   $clusters
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
  $gridname = 'unspecified',
  $cluster  = 'my_cluster',
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

	concat::fragment { "gmetad.conf_footer":
		order   => 99,
		content => template('ganglia/gmetad.conf.foot'),
		target => '/etc/ganglia/gmetad.conf',
	}

	concat::fragment { "data_sources_start":
		order  => 10,
                content => "\ndata_source \"$cluster\" ",
		target => '/etc/ganglia/gmetad.conf',
	}

	Concat::Fragment <<| tag == "ganglia_data_source_$cluster" |>> {
		order  => 11,
		target => '/etc/ganglia/gmetad.conf',
	}

	concat::fragment { "data_sources_end":
		order   => 12,
		content => "\n\n",
		target  => '/etc/ganglia/gmetad.conf',
	}

}
