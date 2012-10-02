class Creosote::Package::MPC < Creosote::Package::Base
  # List of packages that were uploaded in the last `days` days. Default timeframe is 2 years
  def self.recent_packages(days=365*2)
    results = []
    self.ftp_listing do |entry|
      next unless entry =~ /mpc-\d/
      if match = entry.match(/^
                             ([a-z\-]+)\s+        # permissions
                             (\d+)\s+             # ...
                             (\d+)\s+             # ...
                             (\S+)\s+             # owner
                             (\d+)\s+             # size?
                             (\w+\s+\d+\s+\d+)\s+ # ctime
                             (\S+)                # file name
                             /x)
        date = Date.parse(match[6])
        results << entry if (Date.today - date).to_i < days
      elsif match = entry.match(/^
                                ([a-z\-]+)\s+     # permissions
                                (\d+)\s+          # ...
                                (\d+)\s+          # ...
                                (\S+)\s+          # owner
                                (\d+)\s+          # size?
                                (\w+\s+\d+)\s+    # month day
                                \d+:\d+\s+        # hour:min
                                (\S+)             # file name
                                /x)
        date = Date.parse("#{match[6]} #{Date.today.year}")
        results << entry if (Date.today - date).to_i < days
      end
    end

    # We are _not_ returning the raw FTP listings. That crap is crap.
    results.map { |e| (e =~ /(mpc-\d+\.\d+\.\d+)/ && $1) || e }.uniq
  end

  # Return an iterator or array of the FTP listings of the MPC FTP directory
  def self.ftp_listing
    Net::FTP.open('ftp.gnu.org') do |ftp|
      ftp.login
      ftp.chdir 'gnu/mpc'
      if block_given?
        ftp.list() { |entry| yield entry }
      else
        ftp.list()
      end
    end
  end
end
