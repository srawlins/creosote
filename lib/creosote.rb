module Creosote
  PackagePath    = File.join(ENV['HOME'], '.creosote', 'usr')
  PackageSrcPath = File.join(ENV['HOME'], '.creosote', 'src')
end

require File.join(File.dirname(__FILE__), 'creosote', 'package')
require File.join(File.dirname(__FILE__), 'creosote', 'installer')
require File.join(File.dirname(__FILE__), 'creosote', 'tee')
