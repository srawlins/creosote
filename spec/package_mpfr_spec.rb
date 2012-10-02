require File.join(File.dirname(__FILE__), 'spec_helper')

describe Creosote::Package::MPFR do
  it "should list recent packages, at least one", :scope => :integration do
    Creosote::Package::MPFR.recent_packages.should_not be_empty
  end
end
