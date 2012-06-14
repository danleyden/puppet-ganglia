# Class: ganglia::webserver
#
# This class installs the ganglia web server
#
# Parameters:
#
# Actions:
#   installs the ganglia web server
#
# Sample Usage:
#   include ganglia::server
#
class ganglia::webserver {

  $ganglia_webserver_pkg = 'ganglia-webfrontend'

  package {$ganglia_webserver_pkg:
    ensure => present,
    alias  => 'ganglia_webserver',
  }

  file {'/etc/apache2/sites-enabled/ganglia':
    ensure  => present,
    require => Package['ganglia_webserver'],
    content => template('ganglia/ganglia');
  }
}
