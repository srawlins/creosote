require 'mkmf'

class Creosote::Package::Base
  SortDecomposition = proc do |f|
    res = f.split(/[^[:alnum:]]+/).map {|e| e.split(/(?<=[0-9])(?=[^0-9])|(?<=[a-z])(?=[^a-z])/i) }.flatten.map {|e| e =~ /^\d+$/ ? e.to_i : e }
    until res.size >= 7
      res.push 0
    end
    res
  end

  def self.latest_package
    recent = self.recent_packages
    return nil if recent.empty?

    recent.sort_by(&(self::SortDecomposition)).last
  end

  def self.installed(options)
    paths = Dir.glob(File.join(Creosote::PackagePath, prefix+"*")).select { |path| path =~ /#{prefix}-\d/ }

    $configure_args["--with-creosote-include"] = File.join(Creosote::PackagePath, 'include')
    $configure_args["--with-creosote-lib"] = File.join(Creosote::PackagePath, 'lib')
    dir_config('creosote')

    if (options[:default_only])
      success =            try_headers
      success = success && try_libraries
      return success ?
        Creosote::PackagePath :
        false
    else
      configure_args_before = $configure_args.dup
      success =            try_headers   || try_headers_successively_with(paths)
      success = success && try_libraries || try_libraries_successively_with(paths)
      #puts ($configure_args.dup.delete_if {|k,v| configure_args_before.keys.include? k}).inspect
      return success ?
        true :  # can replace this with some form of $configure_args
        false
    end
  end

  def self.try_headers(path="default include paths")
    headers.each do |header|
      if try_header(header)
        ok_line "#{header} is available in #{path}."
        return true
      else
        fail_line "#{header} is not available in #{path}."
        return false
      end
    end
  end

  def self.try_headers_successively_with(paths)
    paths.each do |path|
      arg = "--with-#{prefix}-dir"
      $configure_args[arg] = path
      try_headers(path)
    end
  end

  def self.try_libraries(path="default lib paths", &b)
    libraries.each do |library|
      lib = library[0]
      func = library[1]
      func = "main" if !func or func.empty?
      #libpath = $LIBPATH
      libs = append_library('', lib)
      if try_func(func, libs, &b)
        ok_line "#{lib} library with #{func}() is available in #{path}."
        return true
      else
        fail_line "#{lib} library with #{func}() is not available in #{path}."
        return false
      end
    end
  end

  def self.try_libraries_successively_with(paths)
    paths.each do |path|
      arg = "--with-#{prefix}-lib"
      $configure_args[arg] = File.join(path, 'lib')
      dir_config(prefix)
      try_libraries(File.join(path, 'lib'))
    end
  end

  def self.ok_line(message)
    status = HighLine.color('[OK]', HighLine::BOLD, HighLine::GREEN)
    space = ' ' * (Creosote::Columns - (message.size + status.size))
    puts message + space + status
  end

  def self.fail_line(message)
    status = HighLine.color('[FAIL]', HighLine::BOLD, HighLine::RED)
    space = ' ' * (Creosote::Columns - (message.size + status.size))
    puts message + space + status
  end
end
