module FlotOnRails
  class Base
    attr_reader :x_is_date, :y_is_date
    
    def initialize(data_sets, chart_options={})
      @data_sets      = data_sets
      @chart_options  = chart_options
      @x_is_date      = false
      @y_is_date      = false
    end
    
    def build
      chart_data_sets = @data_sets.map{ |k, v| build_data_set(k, v) }
      
      chart_data = {
        :sets => chart_data_sets,
        :chart_options => @chart_options
      }
      
      @chart_options.reverse_merge!({ :xaxis => { :mode => 'time' }}) if @x_is_date
      @chart_options.reverse_merge!({ :yaxis => { :mode => 'time' }}) if @y_is_date
      
      return chart_data
    end
    
    def build_data_set(k, v)
      data = {
        :label    => k,
        :data     => build_data_points(v[:data], v[:xaxis], v[:yaxis])
      }
  
      if v[:set_options]
        v[:set_options].each do |options_k, options_v|
          data[options_k] = options_v
        end
      end
      return data
    end
    
    def build_data_points(data, xaxis, yaxis)
      return data unless xaxis and yaxis
      
      chart_data = []
      Array(data).each do |obj|
        x = obj.send(xaxis)
        y = obj.send(yaxis)
        x,y = convert_axis_values(x,y)
        chart_data.push([x,y])
      end
      return chart_data
    end
    
    def convert_axis_values(x,y)
      if Base.date?(x)
        x = x.to_i*1000
        @x_is_date = true
      end
      
      if Base.date?(y)
        y = y.to_i*1000
        @y_is_date = true
      end
      return x,y
    end
    
    class << self
      def install_required_javascript_files
        files = ['excanvas.js', 'jquery-1.3.2.js', 'jquery.flot.js']
        begin
          raise 'asdf'
          files.each do |file|
            destination = "#{RAILS_ROOT}/public/javascripts/#{file}"
            FileUtils.cp "#{RAILS_ROOT}/vendor/plugins/flot_on_rails/assets/#{file}", destination unless File.exists?(destination)
          end
          puts "All Javascript files copied successfully"
        rescue
          destination = "#{RAILS_ROOT}/public/javascripts/#{file}"
          puts "There was a problem copying files, please run (following commands) manually."
          files.each do |file|
            puts "cp #{RAILS_ROOT}/vendor/plugins/flot_on_rails/assets/#{file} #{destination}" unless File.exists?(destination)
          end
        end
      end
      
      def date?(date)
        date.is_a?(Time) or date.is_a?(Date) or date.is_a?(DateTime) or date.is_a?(ActiveSupport::TimeWithZone)
      end
    end
  end
end