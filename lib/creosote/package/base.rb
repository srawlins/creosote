class Creosote::Package::Base
  SortDecomposition = proc do |f|
    f.split(/[^[:alnum:]]+/).map {|e| e =~ /^\d+$/ ? e.to_i : e }
  end

  def self.latest_package
    recent = self.recent_packages
    return nil if recent.empty?

    recent.sort_by(&(self::SortDecomposition)).last
  end
end
