require 'open4'

module Creosote; end

class Creosote::Installer
  def self.installer_class(package_name)
    name = Creosote::Installer.constants.select { |c| c.to_s.underscore == package_name.underscore }.first
    raise NameError.new("Creosote::Installer::#{package_name.underscore.camelize}") if name.nil?
    "Creosote::Installer::#{name}".constantize
  end
end

require File.join(File.dirname(__FILE__), 'installer', 'base')
require File.join(File.dirname(__FILE__), 'installer', 'gmp')
#require File.join(File.dirname(__FILE__), 'package', 'mpc')
require File.join(File.dirname(__FILE__), 'installer', 'mpfr')
#require File.join(File.dirname(__FILE__), 'package', 'msieve')
