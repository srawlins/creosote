class Creosote::Package::Msieve < Creosote::Package::Base
  RecentPackages = [
    {:date => Date.parse('2012-02-03'), :version => 'msieve150'},
    {:date => Date.parse('2011-06-16'), :version => 'msieve149'},
    {:date => Date.parse('2011-01-08'), :version => 'msieve148'},
    {:date => Date.parse('2010-09-19'), :version => 'msieve147'}
  ]
  # List of packages that were uploaded in the last 2 years
  def self.recent_packages(days = 2*365)
    results = []
    RecentPackages.each do |hash|
      results << hash[:version] if (Date.today - hash[:date]).to_i < days
    end

    results
  end
end
