class Creosote::Installer::MPFR < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.bz2"
  end

  def verbose(*args)
    puts(*args)
  end

  def install(options={})
    ensure_sane
    cd_src_base
    expand
    cd_src
    versioned_configure
    make
    make_check
    make_install
    if options[:default]
      base_configure
      make_install
    end
  end

  def ensure_sane
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
end
