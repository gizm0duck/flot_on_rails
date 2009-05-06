require File.dirname(__FILE__) + '/../spec_helper'
Struct.new("TrainingSession", :date, :distance, :activity_id)

describe "build" do
  before(:each) do
    @three_mile_run = Struct::TrainingSession.new(Time.parse('dec 3, 2008'), 3, 0)
    @five_mile_run = Struct::TrainingSession.new(Time.parse('dec 4, 2008'), 5, 0)
    @data = [@three_mile_run, @five_mile_run]
    
    @chart = FlotOnRails::Base.new({'running' => {:data => @data, :xaxis => 'date', :yaxis => 'distance'}}, {:grid => {:backgroundColor => 'yellow'}} )
  end
  it "should build the set data properly" do
    data = @chart.build
    data[:sets].first[:data].should eql([[1228291200000, 3], [1228377600000, 5]])
  end
  it "should build the chart_options data properly" do
    data = @chart.build
    data[:chart_options][:grid][:backgroundColor].should eql('yellow')
  end
  it "should set xaxis mode to true if xaxis value is a date type" do
    data = @chart.build
    data[:chart_options][:xaxis][:mode].should eql('time')
  end
  
  it "should set yaxis mode to true if yaxis value is a date type" do
    @chart = FlotOnRails::Base.new({'running' => {:data => @data, :xaxis => 'distance', :yaxis => 'date'}})
    data = @chart.build
    data[:chart_options][:yaxis][:mode].should eql('time')
  end
end

describe "build_data_set" do
  before(:each) do
    @three_mile_run = Struct::TrainingSession.new(Time.parse('dec 3, 2008'), 3, 0)
    @five_mile_run = Struct::TrainingSession.new(Time.parse('dec 4, 2008'), 5, 0)
    @data = [@three_mile_run, @five_mile_run]
    
    @chart = FlotOnRails::Base.new({})
  end
  
  it "should return the key value as the label for the hash" do
    values = @chart.build_data_set('running!', {:data => @data, :xaxis => 'date', :yaxis => 'distance'})
    values[:label].should eql('running!')
  end
  
  it "should return the data in the data key of the returned hash" do
    values = @chart.build_data_set('running!', {:data => @data, :xaxis => 'date', :yaxis => 'distance'})
    values[:data].should eql([[1228291200000, 3], [1228377600000, 5]])
  end
  
  it "should return the data_set options in the options key of the returned hash" do
    values = @chart.build_data_set('running!', {:data => @data, :xaxis => 'date', :yaxis => 'distance', :set_options => {:lines => {:show => true}}})
    values[:lines][:show].should be_true
  end
end

describe "build_data_points" do
  
  before(:each) do
    @three_mile_run = Struct::TrainingSession.new(Time.parse('dec 3, 2008'), 3, 0)
    @five_mile_run = Struct::TrainingSession.new(Time.parse('dec 4, 2008'), 5, 0)
    @data = [@three_mile_run, @five_mile_run]
    
    @chart = FlotOnRails::Base.new({})
  end
  
  it "should set the axis values" do
    values = @chart.build_data_points(@data, 'activity_id', 'distance')
    values.should eql([[0, 3], [0, 5]])
  end
  
  it "should convert values to timestamp in ms if x value is date" do
    values = @chart.build_data_points(@data, 'date', 'distance')
    values.should eql([[1228291200000, 3], [1228377600000, 5]])
  end
end

describe "convert_axis_values" do
  before(:each) do
    @chart = FlotOnRails::Base.new({})
    @time = Time.parse('dec 3, 2008')
  end
  
  it "should convert x to date if is a date format" do
    x,y = @chart.convert_axis_values(@time, 5)
    x.should eql(1228291200000)
  end
  
  it "should convert y to date if is a date format" do
    x,y = @chart.convert_axis_values(5, @time)
    y.should eql(1228291200000)
  end
  
  it "should NOT convert x to date if is a date format" do
    x,y = @chart.convert_axis_values(1000, 5)
    x.should eql(1000)
  end
  
  it "should NOT convert y to date if is a date format" do
    x,y = @chart.convert_axis_values(5, 1001)
    y.should eql(1001)
  end
  
  it "should set x_is_date if xaxis is a date format" do
    x,y = @chart.convert_axis_values(@time, 1001)
    @chart.x_is_date.should be_true
  end
  
  it "should set y_is_date if xaxis is a date format" do
    x,y = @chart.convert_axis_values(1001, @time)
    @chart.y_is_date.should be_true
  end
  
  it "should NOT set x_is_date if xaxis is not a date format" do
    x,y = @chart.convert_axis_values(1001, 5)
    @chart.x_is_date.should be_false
  end
  
  it "should NOT set y_is_date if yaxis is not a date format" do
    x,y = @chart.convert_axis_values(1001, 5)
    @chart.y_is_date.should be_false
  end
end
