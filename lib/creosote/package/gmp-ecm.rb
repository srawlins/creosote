class Creosote::Package::GMP_ECM < Creosote::Package::Base
  def self.prefix; 'gmp-ecm' end
  def self.headers; ['ecm.h']; end
  def self.libraries; [['ecm', 'ecm_init']]; end

  def self.data
    @@data
  end

  # List of packages that were uploaded in the last `days` days. Default timeframe is 2 years
  def self.recent_packages(days=365*2)
    results = []
    @@data ||= Creosote::Package.data_for('gmp-ecm')
    return @@data['versions'].keys
  end
end
