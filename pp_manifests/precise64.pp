group { "puppet":
  ensure => "present",
}

class apt {
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  # Ensure apt is setup before running apt-get update
  Apt::Key <| |> -> Exec["apt-update"]
  Apt::Source <| |> -> Exec["apt-update"]

  # Ensure apt-get update has been run before installing any packages
  Exec["apt-update"] -> Package <| |>
}

if ! defined(Package['build-essential'])      { package { 'build-essential':      ensure => installed } }

include rvm

rvm_system_ruby {
  'ruby-1.9.3-p194':
    ensure => 'present',
    default_use => true;
  'ruby-1.8.7-p370':
    ensure => 'present',
    default_use => false;
}

rvm_gemset {
  "ruby-1.9.3-p194@creosote":
    ensure => 'present',
    require => Rvm_system_ruby['ruby-1.9.3-p194'];
}

rvm_gem {
  'ruby-1.9.3-p194/puppet':
    require => Rvm_system_ruby['ruby-1.9.3-p194'];
  'ruby-1.9.3-p194@creosote/bundler':
    require => Rvm_gemset['ruby-1.9.3-p194@creosote'];
}
