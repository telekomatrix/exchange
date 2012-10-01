require 'spec_helper'

describe "Exchange::Conversability" do
  before(:all) do
    Exchange.configuration = Exchange::Configuration.new { |c| c.cache = { :subclass => :no_cache } }
  end
  before(:each) do
    @time = Time.gm(2012,8,27)
    Time.stub! :now => @time
  end
  after(:all) do
    Exchange::configuration = Exchange::Configuration.new { |c| c.cache = { :subclass => :memcached } }
  end
  it "should define all currencies on Fixnum, Float and BigDecimal" do
    Exchange::ISO4217.definitions.keys.each do |c|
      1.should be_respond_to(c.downcase.to_sym)
      1.1.should be_respond_to(c.downcase.to_sym)
      BigDecimal.new("1").should be_respond_to(c.downcase.to_sym)
    end
  end
  context "with a fixnum" do
    it "should allow to convert to a currency" do
      3.eur.should be_kind_of Exchange::Currency
      3.eur.value.should == 3
    end
    it "should allow to convert to a curreny with a negative number" do
      -3.eur.should be_kind_of Exchange::Currency
      -3.eur.value.should == -3
    end
    it "should allow to do full conversions" do
      mock_api("http://api.finance.xaviermedia.com/api/2012/08/27.xml", fixture('api_responses/example_xml_api.xml'), 3)
      3.eur.to_chf.should be_kind_of Exchange::Currency
      3.eur.to_chf.value.round(2).should == 3.68
      3.eur.to_chf.currency.should == 'chf'
    end
    it "should allow to do full conversions with negative numbers" do
      mock_api("http://api.finance.xaviermedia.com/api/2012/08/27.xml", fixture('api_responses/example_xml_api.xml'), 3)
      -3.eur.to_chf.should be_kind_of Exchange::Currency
      -3.eur.to_chf.value.round(2).should == -3.68
      -3.eur.to_chf.currency.should == 'chf'
    end
    it "should allow to define a historic time in which the currency should be interpreted" do
      3.chf(:at => Time.gm(2010,1,1)).time.yday.should == 1
      3.chf(:at => Time.gm(2010,1,1)).time.year.should == 2010
      3.chf(:at => '2010-01-01').time.year.should == 2010
    end
  end
  context "with a float" do
    it "should allow to convert to a currency" do
      3.25.eur.should be_kind_of Exchange::Currency
      3.25.eur.value.round(2).should == 3.25
    end
    it "should allow to convert to a curreny with a negative number" do
      -3.25.eur.should be_kind_of Exchange::Currency
      -3.25.eur.value.round(2).should == -3.25
    end
    it "should allow to do full conversions" do
      mock_api("http://api.finance.xaviermedia.com/api/2012/08/27.xml", fixture('api_responses/example_xml_api.xml'), 3)
      3.25.eur.to_chf.should be_kind_of Exchange::Currency
      3.25.eur.to_chf.value.round(2).should == 3.99
      3.25.eur.to_chf.currency.should == 'chf'
    end
    it "should allow to do full conversions with negative numbers" do
      mock_api("http://api.finance.xaviermedia.com/api/2012/08/27.xml", fixture('api_responses/example_xml_api.xml'), 3)
      -3.25.eur.to_chf.should be_kind_of Exchange::Currency
      -3.25.eur.to_chf.value.round(2).should == -3.99
      -3.25.eur.to_chf.currency.should == 'chf'
    end
    it "should allow to define a historic time in which the currency should be interpreted" do
      3.25.chf(:at => Time.gm(2010,1,1)).time.yday.should == 1
      3.25.chf(:at => Time.gm(2010,1,1)).time.year.should == 2010
      3.25.chf(:at => '2010-01-01').time.year.should == 2010
    end
  end
  context "with a big decimal" do
    it "should allow to convert to a currency" do
      BigDecimal.new("3.25").eur.should be_kind_of Exchange::Currency
      BigDecimal.new("3.25").eur.value.round(2).should == 3.25
    end
    it "should allow to convert to a curreny with a negative number" do
      BigDecimal.new("-3.25").eur.should be_kind_of Exchange::Currency
      BigDecimal.new("-3.25").eur.value.round(2).should == -3.25
    end
    it "should allow to do full conversions" do
      mock_api("http://api.finance.xaviermedia.com/api/2012/08/27.xml", fixture('api_responses/example_xml_api.xml'), 3)
      BigDecimal.new("3.25").eur.to_chf.should be_kind_of Exchange::Currency
      BigDecimal.new("3.25").eur.to_chf.value.round(2).should == 3.99
      BigDecimal.new("3.25").eur.to_chf.currency.should == 'chf'
    end
    it "should allow to do full conversions with negative numbers" do
      mock_api("http://api.finance.xaviermedia.com/api/2012/08/27.xml", fixture('api_responses/example_xml_api.xml'), 3)
      BigDecimal.new("-3.25").eur.to_chf.should be_kind_of Exchange::Currency
      BigDecimal.new("-3.25").eur.to_chf.value.round(2).should == -3.99
      BigDecimal.new("-3.25").eur.to_chf.currency.should == 'chf'
    end
    it "should allow to define a historic time in which the currency should be interpreted" do
      BigDecimal.new("3.25").chf(:at => Time.gm(2010,1,1)).time.yday.should == 1
      BigDecimal.new("3.25").chf(:at => Time.gm(2010,1,1)).time.year.should == 2010
      BigDecimal.new("3.25").chf(:at => '2010-01-01').time.year.should == 2010
    end
  end
end