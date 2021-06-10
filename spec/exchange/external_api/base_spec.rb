# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Exchange::ExternalAPI::Base" do
  subject { Exchange::ExternalAPI::Base.new }
  before(:all) do
    Exchange.configuration = Exchange::Configuration.new{|c|
      c.cache = {:subclass => :no_cache}
    }
  end
  after(:all) do
    Exchange.configuration.reset
  end
  before(:each) do
    subject.instance_variable_set("@rates", {:eur => BigDecimal("3.45"), :chf => BigDecimal("5.565")})
    subject.instance_variable_set("@base", :usd)
  end
  describe "rate" do
    it "should put out an exchange rate for the two currencies" do
      subject.should_receive(:update).once
      subject.rate(:eur, :chf).round(3).should == 1.613
    end
    it "should put out an exchange rate for the two currencies and pass on opts" do
      time = Time.now
      subject.should_receive(:update).with(:at => time).once
      subject.rate(:eur, :chf, :at => time).round(3).should == 1.613
    end
  end
  describe "convert" do
    it "should convert according to the given rates" do
      subject.should_receive(:update).once
      subject.convert(80,:chf, :eur).round(2).should == 49.6
    end
    it "should convert according to the given rates and pass opts" do
      time = Time.now
      subject.should_receive(:update).with(:at => time).once
      subject.convert(80,:chf, :eur, :at => time).round(2).should == 49.6
    end
  end
end
