require 'net/http'
require 'uri'

require 'open4'

module Creosote; end

class Creosote::Installer
  SPINNERS = %w{ | / - \\ }
  @@spinner_index = 0

  def self.installer_class(package_name)
    name = Creosote::Installer.constants.select { |c| c.to_s.underscore == package_name.underscore }.first
    raise NameError.new("Creosote::Installer::#{package_name.underscore.camelize}") if name.nil?
    "Creosote::Installer::#{name}".constantize
  end

  def self.spin
    print "\b"+SPINNERS[@@spinner_index]
    @@spinner_index = (@@spinner_index + 1) % 4
  end
end

require File.join(File.dirname(__FILE__), 'installer', 'base')
require File.join(File.dirname(__FILE__), 'installer', 'gmp')
require File.join(File.dirname(__FILE__), 'installer', 'mpc')
require File.join(File.dirname(__FILE__), 'installer', 'mpfr')
#require File.join(File.dirname(__FILE__), 'package', 'msieve')
