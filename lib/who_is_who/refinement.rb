module WhoIsWho
  module Scraper
    module Refinement
      module Text
        refine String do
          def clean
            cleaned = gsub("\n", "").gsub("\t", "").gsub(" ", "").strip
            return '' if cleaned == '.'
            cleaned
          end

          def titlecase
            self.downcase.split(' ').map do |word|
              if %{a o el la en las los de que}.include?(word)
                word
              else
                word[0].upcase + word[1..-1]
              end
            end.join(' ')
          end
        end
      end
    end
  end
end
