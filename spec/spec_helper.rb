require 'bundler/setup'
require 'who_is_who'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def url_content(name)
  open("spec/data/#{name}.html")
end
