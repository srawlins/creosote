class Creosote::Installer::GMP < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.bz2"
  end

  def verbose(*args)
    puts(*args)
  end

  def install
    ensure_sane
    cd_src_base
    expand
    cd_src
    versioned_configure
    make
    make_check
    make_install
    base_configure
    make_install
  end

  def ensure_sane
  end

  def expand
    command = "tar -xjf #{@src_download}"
    #verbose command
    #`#{command} #{redirects 'tar'}`
    system(command, log_prefix: 'tar')
  end

  def system(command, options={})
    options = {log_prefix: 'system'}.merge options
    case @verbosity
    when :silent
      `#{command} #{redirects options[:log_prefix]}`
    when :summary
      puts command
      `#{command} #{redirects options[:log_prefix]}`
    when :verbose
      print_and_log_system(command, options)
    else # same as :summary
      puts command
      `#{command} #{redirects options[:log_prefix]}`
    end
  end

  def print_and_log_system(command, options={})
    options = {log_prefix: 'system'}.merge options
    puts command
    out_log_handle = File.open(File.join(package_src_dir, "#{options[:log_prefix]}.out"), 'a+')
    err_log_handle = File.open(File.join(package_src_dir, "#{options[:log_prefix]}.err"), 'a+')
    stdout = Tee.new($stdout, out_log_handle)
    stderr = Tee.new($stderr, err_log_handle)
    status = Open4::spawn(command, {stdout: stdout, stderr: stderr})
    status
  ensure
    out_log_handle.close if out_log_handle
    err_log_handle.close if err_log_handle
  end

  def base_configure
    command = "./configure --prefix=#{Creosote::PackagePath}"
    system(command, log_prefix: 'base-configure')
  end

  def versioned_configure
    command = "./configure --prefix=#{package_dir}"
#    verbose command
#    `#{command} #{redirects 'versioned_configure'}`
    system(command, log_prefix: 'versioned-configure')
  end

  def make
    command = "make"
#    verbose command
#    `#{command} #{redirects 'make'}`
    system(command, log_prefix: 'make')
  end

  def make_check
    command = "make check"
#    verbose command
#    `#{command} #{redirects 'make_check'}`
    system(command, log_prefix: 'make-check')
  end

  def make_install
    command = "make install"
    verbose command
    `#{command} #{redirects 'make_check'}`
  end

  def redirects(prefix)
    "2> #{prefix}-#{@version}.err > #{prefix}-#{@version}.out"
  end
end
