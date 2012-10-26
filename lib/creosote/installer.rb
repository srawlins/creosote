require 'open4'

module Creosote; end

class Creosote::Installer
end

require File.join(File.dirname(__FILE__), 'installer', 'base')
require File.join(File.dirname(__FILE__), 'installer', 'gmp')
#require File.join(File.dirname(__FILE__), 'package', 'mpc')
#require File.join(File.dirname(__FILE__), 'package', 'mpfr')
#require File.join(File.dirname(__FILE__), 'package', 'msieve')
