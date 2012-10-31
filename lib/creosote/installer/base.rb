class Creosote::Installer::Base
  attr_accessor :verbosity, :version

  def base_configure
    command = "./configure --prefix=#{Creosote::PackagePath}"
    system(command, log_prefix: 'base-configure')
  end

  def cd_src_base
    verbose "cd #{Creosote::PackageSrcPath}"
    Dir.chdir(Creosote::PackageSrcPath)
  end

  def cd_src
    src_path = File.join(Creosote::PackageSrcPath, @version)
    verbose "cd #{src_path}"
    Dir.chdir(src_path)
  end

  def expand
    command = "tar -xjf #{@src_download}"
    system(command, log_prefix: 'tar')
  end

  def make
    command = "make"
    system(command, log_prefix: 'make')
  end

  def make_check
    command = "make check"
    system(command, log_prefix: 'make-check')
  end

  def make_install
    command = "make install"
    verbose command
    `#{command} #{redirects 'make_check'}`
  end

  def package_src_dir
    File.join(Creosote::PackageSrcPath, @version)
  end

  def package_dir
    File.join(Creosote::PackagePath, @version)
  end

  def redirects(prefix)
    "2> #{prefix}-#{@version}.err > #{prefix}-#{@version}.out"
  end

  def system(command, options={})
    options = {log_prefix: 'system'}.merge options
    result = nil
    case @verbosity
    when :silent
      `#{command} #{redirects options[:log_prefix]}`
      result = $?.exitstatus
    when :summary
      puts command
      `#{command} #{redirects options[:log_prefix]}`
      result = $?.exitstatus
    when :verbose
      print_and_log_system(command, options)
    else # same as :summary
      puts command
      `#{command} #{redirects options[:log_prefix]}`
      result = $?.exitstatus
    end
    if result != 0
      raise StandardError
    end
  end

  def versioned_configure
    command = "./configure --prefix=#{package_dir}"
    system(command, log_prefix: 'versioned-configure')
  end
end
