class Creosote::Installer::Base
  attr_accessor :verbosity, :version

  Expanders = {
    '.bz2' => 'tar -xjf',
    '.gz'  => 'tar -xzf'
  }

  def base_configure
    command = "./configure --prefix=#{Creosote::PackagePath} #{@configure_opts}"
    system(command, log_prefix: 'base-configure')
  end

  def cd_src_base
    case @verbosity
    when :silent
    when :summary
      puts "cd #{Creosote::PackageSrcPath}"
    when :verbose
      puts "cd #{Creosote::PackageSrcPath}"
    else
      puts "cd #{Creosote::PackageSrcPath}"
    end
    Dir.chdir(Creosote::PackageSrcPath)
  end

  def expanded_path
    @expanded_path ||= if (@package_klass.data['versions'][@version]['extracted_dir'])
      File.join(Creosote::PackageSrcPath, @package_klass.data['versions'][@version]['extracted_dir'])
    else
      File.join(Creosote::PackageSrcPath, @version)
    end
  end

  def cd_src
    case @verbosity
    when :silent
    when :summary
      puts "cd #{expanded_path}"
    when :verbose
      puts "cd #{expanded_path}"
    else
      puts "cd #{expanded_path}"
    end
    Dir.chdir(expanded_path)
  end

  def install_dependencies
    return unless @dependencies
    @dependencies.each do |dep|
      next if Creosote::Package.installed(dep, :default_only => true)
      Creosote::Package.install(dep, :default => true)
    end
  end

  def download
    if @package_klass.data['base_url']
      @uri = URI.parse(@package_klass.data['base_url'])
    else
      @uri = URI.parse(@package_klass.data['versions'][@version]['url'])
    end
    handle = File.open(@src_download, 'wb')
    opts = {}
    opts[:use_ssl] = true if @uri.scheme == 'https'
    Net::HTTP.start(@uri.host, opts) do |http|
      print "downloading #{@uri.host}#{@uri.path}/#{@src_download}...."
      http.request_get("#{@uri.path}/#{@src_download}") do |resp|
        resp.read_body do |segment|
          handle.write(segment)
          Creosote::Installer.spin
        end
      end
      print("\b")
    end
    handle.close
    print "\n"
  end

  def downloaded?
    File.exists?(@src_download)
  end

  def ensure_sane
    [Creosote::PackagePath, Creosote::PackageSrcPath].each do |path|
      if not File.exist? path
        FileUtils.mkdir_p path
      end
    end
  end

  def expand
    command = "#{Expanders[File.extname(@src_download)]} #{@src_download}"
    #command = "tar -xjf #{@src_download}"
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

  def make_clean
    command = "make clean"
    system(command, log_prefix: 'make-clean')
  end

  def make_install
    command = "make install"
    system(command, log_prefix: 'make-install')
  end

  def make_uninstall
    command = "make uninstall"
    system(command, log_prefix: 'make-uninstall')
  end

  def package_src_dir
    File.join(Creosote::PackageSrcPath, @version)
  end

  def package_dir
    File.join(Creosote::PackagePath, @version)
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
      print command
      `#{command} #{redirects options[:log_prefix]}`
      result = $?.exitstatus
      $?.exitstatus == 0 ? finish_ok_line(command) : finish_fail_line(command)
    when :verbose
      print_and_log_system(command, options)
    else # same as :summary
      print command
      `#{command} #{redirects options[:log_prefix]}`
      result = $?.exitstatus
      $?.exitstatus == 0 ? finish_ok_line(command) : finish_fail_line(command)
    end
    if result != 0
      raise StandardError
    end
  end

  def finish_ok_line(message)
    status = HighLine.color('[OK]', HighLine::BOLD, HighLine::GREEN)
    space = ' ' * (Creosote::Columns - (message.size + status.size))
    puts space + status
  end

  def finish_fail_line(message)
    status = HighLine.color('[FAIL]', HighLine::BOLD, HighLine::RED)
    space = ' ' * (Creosote::Columns - (message.size + status.size))
    puts space + status
  end

  def versioned_configure
    command = "./configure --prefix=#{package_dir} #{@configure_opts}"
    system(command, log_prefix: 'versioned-configure')
  end
end
