require 'bundler/setup'
require 'who_is_who'
require 'open-uri'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def url_content(name)
  Nokogiri::HTML(File.read("spec/data/#{name}.html"), nil, 'UTF-8')
end
