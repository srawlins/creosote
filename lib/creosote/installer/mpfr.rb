class Creosote::Installer::MPFR < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.bz2"
  end

  def install(package_klass, options={})
    @package_klass = package_klass
    ensure_sane
    cd_src_base
    download
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
end
