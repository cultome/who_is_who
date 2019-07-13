module WhoIsWho
  module Scraper
    class Diputados
      include WhoIsWho::Scraper::Utils

      LIST_URL = 'http://sitl.diputados.gob.mx/LXIV_leg/listado_diputados_gpnp.php?tipot=TOTAL'

      def ids
        doc = parse(LIST_URL)
        doc
          .css('a.linkVerde')
          .map { |link| link.attr('href') }
          .map { |href| href.gsub('curricula.php?dipt=', '') }
          .map(&:to_i)
          .sort
      end
    end
  end
end
