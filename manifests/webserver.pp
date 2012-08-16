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
class ganglia::webserver (
  $use_alias = true,
) {

  $ganglia_webserver_pkg = $::osfamily ? {
    Debian => 'ganglia-webfrontend',
    RedHat => 'ganglia-wed',
  }

  package {$ganglia_webserver_pkg:
    ensure => present,
    alias  => 'ganglia_webserver',
  }

  file {'/etc/apache2/sites-enabled/ganglia':
    ensure  => '/etc/apache2/sites-available/ganglia',
    require => File['/etc/apache2/sites-available/ganglia'],
  }

  file {'/etc/apache2/sites-available/ganglia':
    ensure  => present,
    require => Package['ganglia_webserver'],
    content => template('ganglia/ganglia');
  }
}
