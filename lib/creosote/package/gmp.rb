class Creosote::Package::GMP < Creosote::Package::Base
  def self.prefix; 'gmp' end
  def self.headers; ['gmp.h']; end
  def self.libraries; [['gmp', '__gmpz_init']]; end

  def self.data
    @@data
  end

  # List of packages that were uploaded in the last 2 years
  def self.recent_packages
    results = []
    if @somehow_signifying_that_we_want_to_use_ftp.nil?
      @@data ||= Creosote::Package.data_for('gmp')
      return @@data['versions'].keys
    else
      self.ftp_listing do |entry|
        next unless entry =~ /gmp-\d/
        if match = entry.match(/^([a-z\-]+)\s+(\d+)\s+(\d+)\s+(\w+)\s+(\d+)\s+(\w+\s+\d+)\s+\d+:\d+:\d+\s+(\d+)\s+(\S+)/)
          date = Date.parse(match[6]+' '+match[7])
           results << entry if (Date.today - date).to_i < 2*365
         end
      end

      # We are _not_ returning the raw FTP listings. That crap is crap.
      results.map { |e| e.split(/\s+/).last }
    end
  end

  # Return an iterator or array of the FTP listings of the GMP FTP directory
  def self.ftp_listing
    Net::FTP.open('ftp.gmplib.org') do |ftp|
      ftp.login
      ftp.chdir 'pub'
      if block_given?
        ftp.list('-lT') { |entry| yield entry }
      else
        ftp.list('-lT')
      end
    end
  end
end
