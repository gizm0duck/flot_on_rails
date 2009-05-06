# desc "Explaining what the task does"
# task :happy_assets do
#   # Task goes here
# end

namespace :flot_on_rails do
  
  desc "initialization for flot_on_rails plugin"
  task :initialize => :environment do
    FlotOnRails::Base.install_required_javascript_files
  end
end