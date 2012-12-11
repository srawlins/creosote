require 'date'
require 'net/ftp'
require 'yaml'

require 'active_support/inflector'

module Creosote; end

class Creosote::Package
  DataDir = File.join(File.dirname(__FILE__), '..', '..', 'data', 'package')

  def self.data_for(package_name)
    YAML.load File.read(
      File.join(DataDir, package_name+'.yaml')
    )
  end

  def self.available(package_name, options={})
    if package_name.nil?
      self.available_all(options)
    elsif self.known? package_name
      self.available_single(package_name, options)
    else
      raise Creosote::Package::UnknownPackageError(package_name)
    end
  end

  def self.available_all(options={})
    results = {}
    Creosote::Package.constants.sort.each do |c|
      next if c == :Base
      results[c] = available_single(c.to_s, options)
    end
    results
  end

  def self.available_single(package_name, options={})
    klass = self.package_class(package_name)
    if options[:latest]
      klass.latest_package
    else
      klass.recent_packages
    end
  end

  def self.install(package_name, options={})
    if options[:ver]
      version = options[:ver]
      version = package_class(package_name).recent_packages.select { |e| e =~ /#{version}/ }.first
    else
      version = package_class(package_name).latest_package
    end
    installer_class = Creosote::Installer.installer_class(package_name)
    installer = installer_class.new(version)
    installer.install(package_class(package_name), options)
  end

  def self.installed(package_name=nil, options = {})
    if package_name.nil?
      # lots of stuff
    else
    klass = self.package_class(package_name)
    klass.installed(options)
    end
  end

  def self.print_available(package_name, options={})
    results = self.available(package_name, options)

    if results.is_a? Array
      results.each { |result| puts result }
    elsif results.is_a? Hash
      results.each do |name, versions|
        if versions.is_a? Array
          puts "#{name}:"
          versions.each { |version| puts "  #{version}" }
        else
          puts "%-7s  %s" % ["#{name}:", versions]
        end
      end
    else
      puts results
    end
  end

  def self.known?(package_name)
    Creosote::Package.constants.map(&:to_s).map(&:underscore).include? package_name.underscore
  end

  def self.package_class(package_name)
    name = Creosote::Package.constants.select { |c| c.to_s.underscore == package_name.underscore }.first
    raise NameError.new("Creosote::Package::#{package_name.underscore.camelize}") if name.nil?
    "Creosote::Package::#{name}".constantize
  end
end

require File.join(File.dirname(__FILE__), 'package', 'base')
require File.join(File.dirname(__FILE__), 'package', 'gmp')
require File.join(File.dirname(__FILE__), 'package', 'gmp-ecm')
require File.join(File.dirname(__FILE__), 'package', 'mpc')
require File.join(File.dirname(__FILE__), 'package', 'mpfr')
require File.join(File.dirname(__FILE__), 'package', 'msieve')
