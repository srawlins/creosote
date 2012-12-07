class Creosote::Installer::MPC < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.gz"
    @configure_opts = "--with-mpfr=#{Creosote::PackagePath}"
    @dependencies = ['mpfr']
  end

  def install(package_klass, options={})
    @package_klass = package_klass
    ensure_sane
    install_dependencies
    cd_src_base
    download
    expand
    cd_src
    if options[:default]
      base_configure
    else
      versioned_configure
    end
    make_clean
    make
    make_check
    make_install
  end

  def ensure_sane
  end
end
