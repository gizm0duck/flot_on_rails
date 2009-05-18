module FlotOnRails
  module Helper
    def flot_chart(element, data_sets, chart_options={})
      chart = FlotOnRails::Base.new(data_sets, chart_options)
      data = chart.build
      
      ["<script type=\"text/javascript\">",
        "$(function () {",
        "$.plot($('##{element}'), #{data[:sets].to_json}, #{data[:chart_options].to_json});",
        "});",
        "</script>"].join("\n")
    end
    
    def calculate_ticks(data_points, num, axis= :y)

      if FlotOnRails::Base.date?(data_points.first)
        data_points = data_points.map{|data_point| data_point.to_i*1000 }
      end

      min = data_points.min
      max = data_points.max
      range = max-min
      tick_space = 100/(num-1).to_f
      tick_size = range*tick_space/100

      min_tick = [min]
      min_tick << yield(min) if block_given?
      max_tick = [max]
      max_tick << yield(max) if block_given?

      # Calculate all intermediate ticks
      ticks = [min_tick]
      (1..(num-2)).each_with_index do |i, index|
        tick_value = min+(tick_size*(index+1))
        tick = [tick_value]
        tick << yield(tick_value) if block_given?
        ticks << tick
      end
      ticks << max_tick
      tick_data = {:ticks => ticks,
        :min => min,
        :max => max}

      tick_data.merge!({:min => min-tick_size, :max => max+tick_size}) if axis == :y

      return tick_data
    end

    def build_data_line(xdata, ydata, xargs)
      first_x = xdata.first.send(*xargs)
      last_x  = xdata.last.send(*xargs)
      # Assumes that x data is always time related
      [[first_x.to_i*1000, ydata], [last_x.to_i*1000, ydata]]
    end
  end
end

ActionView::Base.send(:include, FlotOnRails::Helper)