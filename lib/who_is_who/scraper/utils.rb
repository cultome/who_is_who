require 'nokogiri'

module WhoIsWho
  module Scraper
    module Utils
      def parse(url)
        Nokogiri::HTML(fetch(url))
      end

      def fetch(url)
        open(url)
      end
    end
  end
end
