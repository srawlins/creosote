require 'rubygems'
require 'rubygems/installer'
require 'rubygems/dependency_installer'

if Gem::VERSION =~ /^1\./  #1.x
  require File.join(File.dirname(__FILE__), '..', 'rubygems', 'dependency_installer')  # Only required until Rubygems 2.0.0
else # 2.x
  require File.join(File.dirname(__FILE__), '..', 'rubygems', 'dependency_installer_2.0.0')  # Only required until Rubygems 2.0.0
end

require File.join(File.dirname(__FILE__), 'gem')

module Creosote; end

class Creosote::GemInstaller < Gem::DependencyInstaller
  def add_extconf_args_for requirement, paths
    if paths.size == 1
      @build_args << "--with-#{requirement}-dir=#{paths.first}"
    else # pairs? like -include and -lib? TODO
    end
  end

  def initialize(name, options={})
    @name = name

    # TODO: This seems a little weird, but it's the best that I can think of for now. I'd like to move this to #install.
    @build_args = options[:build_args] || []
    gem = Creosote::Gem.build(@name)

    gem.dependencies_with_known_requirements.each do |dep_gem|
      next if Gem::Specification.any? { |s| s.name =~ /^#{dep_gem}$/ }

      puts "#{gem.name} requires #{dep_gem}, a gem with known requirements. Installing..."
      dep = Creosote::GemInstaller.new(dep_gem).install
    end

    gem.requirements.each do |requirement|
      check_requirement(requirement)
    end

    if Gem::VERSION =~ /^1\./  # Rubygems 1.x
      Gem::Command.build_args ||= []
      Gem::Command.build_args += @build_args
    else  # Rubygems 2.x
      options.merge!({
        :build_args => @build_args
      })
    end
    super(options)
  end

  # TODO: this should be in Creosote::Package or Creosote::Installer
  def check_requirement(requirement)
    if paths_for_extconf = Creosote::Package.installed(requirement, :default_only => true)
      puts "requirement #{requirement} is already installed at #{paths_for_extconf.inspect}."
      paths_for_extconf = [paths_for_extconf].flatten
      add_extconf_args_for requirement, paths_for_extconf
    else
      puts "requirement #{requirement} is not yet installed. Installing..."
      paths_for_extconf = Creosote::Package.install(requirement, :default => true)
      paths_for_extconf = [paths_for_extconf].flatten
      add_extconf_args_for requirement, paths_for_extconf
    end
  end

  def install
    super(@name)
  end
end
