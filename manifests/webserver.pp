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

  $ganglia_webserver_pkg = $::osfamily ? {
    Debian => 'ganglia-webfrontend',
    RedHat => 'ganglia-web',
    default => fail("Module ${module_name} is not supported on
${::operatingsystem}")
  }

  package {$ganglia_webserver_pkg:
    ensure => present,
    alias  => 'ganglia_webserver',
  }
  file {'/etc/apache2/sites-enabled/ganglia':
    ensure  => link,
    target  => '/etc/apache2/sites-available/ganglia',
    require => File['/etc/apache2/sites-available/ganglia'],
  }

  file {'/etc/apache2/sites-available/ganglia':
    ensure  => present,
    require => Package['ganglia_webserver'],
    content => template('ganglia/ganglia');
  }
}