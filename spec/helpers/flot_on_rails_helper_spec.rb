require File.dirname(__FILE__) + '/../spec_helper'
include ApplicationHelper
include FlotOnRails::Helper

describe FlotOnRails::Helper, "calculate_ticks" do
  before(:each) do
    @data_set = [5,10]
    @data_set.stub!(:min).and_return(5)
    @data_set.stub!(:max).and_return(10)
  end
  it "should calculate correct values for 3 ticks" do
    values = calculate_ticks(@data_set, 3)
    
    values[:max].should eql(12.5)
    values[:min].should eql(2.5)
    values[:ticks].should eql([[5], [7.5], [10]])
  end
  
  it "should calculate correct values for 4 ticks" do
    values = calculate_ticks(@data_set, 5)
    
    values[:max].should eql(11.25)
    values[:min].should eql(3.75)
    values[:ticks].should eql([[5], [6.25], [7.5], [8.75], [10]])
  end
  
  it "should format tick label if block is given" do
    values = calculate_ticks(@data_set, 3){|tick| tick.to_s }
    
    values[:max].should eql(12.5)
    values[:min].should eql(2.5)
    values[:ticks].should eql([[5,'5'], [7.5, '7.5'], [10,'10']])
  end
  
end
