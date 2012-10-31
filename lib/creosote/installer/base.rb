class Creosote::Installer::Base
  attr_accessor :verbosity, :version

  def base_configure
    command = "./configure --prefix=#{Creosote::PackagePath}"
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

  def cd_src
    src_path = File.join(Creosote::PackageSrcPath, @version)
    case @verbosity
    when :silent
    when :summary
      puts "cd #{src_path}"
    when :verbose
      puts "cd #{src_path}"
    else
      puts "cd #{src_path}"
    end
    Dir.chdir(src_path)
  end

  def download
    @uri = URI.parse(@package_klass.data['base_url'])
    handle = File.open(@src_download, 'wb')
    Net::HTTP.start(@uri.host) do |http|
      http.request_get("#{@uri.path}/#{@src_download}") do |resp|
        resp.read_body do |segment|
          handle.write(segment)
          Creosote::Installer.spin
        end
      end
      print("\b")
    end
    handle.close
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
    system(command, log_prefix: 'make-install')
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
