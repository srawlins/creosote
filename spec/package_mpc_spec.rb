require File.join(File.dirname(__FILE__), 'spec_helper')

describe Creosote::Package::MPC do
  it "should list recent packages, at least one", :scope => :integration do
    Creosote::Package::MPC.recent_packages.should_not be_empty
  end
end
