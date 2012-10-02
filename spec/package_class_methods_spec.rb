require File.join(File.dirname(__FILE__), 'spec_helper')

describe Creosote::Package, '.known?' do
  it "should correctly know that good packages are known" do
    Creosote::Package.known?('Mpfr').should be_true
    Creosote::Package.known?('gmp').should be_true
    Creosote::Package.known?('GMP').should be_true
  end

  it "should correctly know that bad packages are not known" do
    Creosote::Package.known?('MpFr').should be_false
  end
end

describe Creosote::Package, '.package_name' do
  it "should correctly name good packages" do
    Creosote::Package.package_class('Mpfr').should be Creosote::Package::MPFR
    Creosote::Package.package_class('gmp').should be Creosote::Package::GMP
    Creosote::Package.package_class('GMP').should be Creosote::Package::GMP
  end

  it "should correctly raise on bad packages" do
    expect {Creosote::Package.package_class('MpFr') }.to raise_error(NameError)
  end
end
