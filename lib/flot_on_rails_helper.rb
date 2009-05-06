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
  end
end

ActionView::Base.send(:include, FlotOnRails::Helper)