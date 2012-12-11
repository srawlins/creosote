require 'gems'

module Creosote; end

class Creosote::Gem
  @@gems = {}

  def initialize(name, version=nil)
    if @@gems.has_key? "#{name}@#{version}"
      return @@gems["#{name}@#{version}"]
    end

    @name = name
    @version = version
    @@gems["#{name}@#{version}"] = self
  end

  def dependencies(recursive=false)
    return @dependencies if @dependencies

    deps = Gems.dependencies(@name).select { |e| e[:name] == @name }

    if @version.nil?
      deps = deps.first
    else
      deps = deps.select { |e| e[:number] == @version }.first
    end

    if deps.nil?
      #puts "deps is nil for #{@name}, #{recursive}, #{version}"
      @dependencies = []
      return []
    end

    deps = deps[:dependencies].flatten

    if not recursive
      @dependencies = deps.each_slice(2).map { |name, version| name }
    else
      deps2 = deps.each_slice(2)
      deps = deps.each_slice(2).map { |name, version| name }
      #puts "%3d: #{@name} => #{deps.inspect}" % @@count
      # TODO: change out to something like ary = Creosote::Gem.build(*gems); Creosote::Gem.dependencies(ary) to save HTTP requests
      deps2.each { |name, version|
        version = version.split(' ').last  # TODO: hack for changing '>= 0.5.47' to '0.5.47'
        deps += Creosote::Gem.new(name, version).dependencies(recursive)
      }
      @dependencies = deps.uniq
    end
    return @dependencies
  end
end
