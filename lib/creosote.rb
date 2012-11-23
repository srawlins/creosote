require 'highline'

module Creosote
  PackagePath    = File.join(ENV['HOME'], '.creosote', 'usr')
  PackageSrcPath = File.join(ENV['HOME'], '.creosote', 'src')

  Columns = HighLine::SystemExtensions.terminal_size[0]
  Rows    = HighLine::SystemExtensions.terminal_size[1]
end


require File.join(File.dirname(__FILE__), 'creosote', 'package')
require File.join(File.dirname(__FILE__), 'creosote', 'installer')
require File.join(File.dirname(__FILE__), 'creosote', 'tee')
