require File.join(File.dirname(__FILE__), 'spec_helper')

describe Creosote::Package::GMP do
  it "should list recent packages, at least one", :scope => :integration do
    Creosote::Package::GMP.recent_packages.should_not be_empty
  end
end
