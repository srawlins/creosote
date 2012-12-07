class Creosote::Installer::GMP < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.bz2"
    @package_prefix = "gmp"
  end

  def install(package_klass, options={})
    @package_klass = package_klass
    ensure_sane
    cd_src_base
    download if not downloaded?
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
end
