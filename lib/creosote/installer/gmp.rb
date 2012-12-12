class Creosote::Installer::GMP < Creosote::Installer::Base
  def initialize(version)
    @version = version
    @src_download = "#{version}.tar.bz2"
    @package_prefix = "gmp"
  end

  def install(package_klass, options={})
    @package_klass = package_klass
    save_pwd
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
    cd_back

    return @paths_for_extconf
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
