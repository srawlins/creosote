class Creosote::Installer::MPFR < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.bz2"
    @configure_opts = "--with-gmp=#{Creosote::PackagePath}"
    @dependencies = ['gmp']
  end

  def install(package_klass, options={})
    @package_klass = package_klass
    save_pwd
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
    cd_back
  end

  def ensure_sane
  end

  def uninstall(package_klass, options={})
    @package_klass = package_klass
    save_pwd
    ensure_sane
    # TODO: assuming a lot of things here
    cd_src_base; cd_src
    if options[:default]
      base_configure
    else
      versioned_configure
    end
    make_uninstall
    cd_back
  end
end
