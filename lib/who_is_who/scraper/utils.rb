require 'nokogiri'
require 'open-uri'

module WhoIsWho
  module Scraper
    module Utils
      def parse(url_template, params={})
        url = build_url(url_template, params)

        Nokogiri::HTML(fetch(url), nil, 'UTF-8')
      end

      def fetch(url)
        open(url)
      end

      def build_url(url_template, params)
        params.reduce(url_template) do |acc, (key, value)|
          acc.gsub("<#{key}>", value.to_s)
        end
      end
    end
  end
end
