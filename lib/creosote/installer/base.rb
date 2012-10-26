class Creosote::Installer::Base
  attr_accessor :verbosity, :version
  def cd_src_base
    verbose "cd #{Creosote::PackageSrcPath}"
    Dir.chdir(Creosote::PackageSrcPath)
  end

  def cd_src
    src_path = File.join(Creosote::PackageSrcPath, @version)
    verbose "cd #{src_path}"
    Dir.chdir(src_path)
  end

  def package_src_dir
    File.join(Creosote::PackageSrcPath, @version)
  end

  def package_dir
    File.join(Creosote::PackagePath, @version)
  end
end
