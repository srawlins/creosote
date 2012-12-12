# THIS FILE MERELY CONTAINS THE FIXES FOUND IN https://github.com/srawlins/rubygems/commit/0ddeb49fcb1a7efb98307a03011d1df89c4a69dd
# WHICH WERE ACCEPTED INTO RUBYGEMS IN https://github.com/rubygems/rubygems/pull/412

class Gem::DependencyInstaller
  DEFAULT_OPTIONS = {
    :env_shebang         => false,
    :document            => %w[ri],
    :domain              => :both, # HACK dup
    :force               => false,
    :format_executable   => false, # HACK dup
    :ignore_dependencies => false,
    :prerelease          => false,
    :security_policy     => nil, # HACK NoSecurity requires OpenSSL. AlmostNo? Low?
    :wrappers            => true,
    :build_args          => nil,
    :build_docs_in_background => false,
  }.freeze

  def initialize(options = {})
    if options[:install_dir] then
      @gem_home = options[:install_dir]

      Gem::Specification.dirs = @gem_home
      Gem.ensure_gem_subdirectories @gem_home
      options[:install_dir] = @gem_home # FIX: because we suck and reuse below
    end

    options = DEFAULT_OPTIONS.merge options

    @bin_dir             = options[:bin_dir]
    @development         = options[:development]
    @domain              = options[:domain]
    @env_shebang         = options[:env_shebang]
    @force               = options[:force]
    @format_executable   = options[:format_executable]
    @ignore_dependencies = options[:ignore_dependencies]
    @prerelease          = options[:prerelease]
    @security_policy     = options[:security_policy]
    @user_install        = options[:user_install]
    @wrappers            = options[:wrappers]
    @build_args          = options[:build_args]

    @installed_gems = []

    @install_dir = options[:install_dir] || Gem.dir
    @cache_dir = options[:cache_dir] || @install_dir

    # Set with any errors that SpecFetcher finds while search through
    # gemspecs for a dep
    @errors = nil
  end

  def install dep_or_name, version = Gem::Requirement.default
    if String === dep_or_name then
      find_spec_by_name_and_version dep_or_name, version, @prerelease
    else
      dep_or_name.prerelease = @prerelease
      @specs_and_sources = [find_gems_with_sources(dep_or_name).last]
    end

    @installed_gems = []

    gather_dependencies

    last = @gems_to_install.size - 1
    @gems_to_install.each_with_index do |spec, index|
      next if Gem::Specification.include?(spec) and index != last

      # TODO: make this sorta_verbose so other users can benefit from it
      say "Installing gem #{spec.full_name}" if Gem.configuration.really_verbose

      _, source_uri = @specs_and_sources.assoc spec
      begin
        local_gem_path = Gem::RemoteFetcher.fetcher.download spec, source_uri,
                                                             @cache_dir
      rescue Gem::RemoteFetcher::FetchError
        next if @force
        raise
      end

      inst = Gem::Installer.new local_gem_path,
                                :bin_dir             => @bin_dir,
                                :development         => @development,
                                :env_shebang         => @env_shebang,
                                :force               => @force,
                                :format_executable   => @format_executable,
                                :ignore_dependencies => @ignore_dependencies,
                                :install_dir         => @install_dir,
                                :security_policy     => @security_policy,
                                :user_install        => @user_install,
                                :wrappers            => @wrappers,
                                :build_args          => @build_args

      spec = inst.install

      @installed_gems << spec
    end

    @installed_gems
  end
end
