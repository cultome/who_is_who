module WhoIsWho
  module Scraper
    class Diputados
      include WhoIsWho::Scraper::Utils

      using WhoIsWho::Scraper::Refinement::Text

      LIST_URL = "http://sitl.diputados.gob.mx/LXIV_leg/listado_diputados_gpnp.php?tipot=TOTAL"
      DETAILS_URL = "http://sitl.diputados.gob.mx/LXIV_leg/curricula.php?dipt=<id>"

      def ids
        doc = parse(LIST_URL)
        doc
          .css("a.linkVerde")
          .map { |link| link.attr("href") }
          .map { |href| href.gsub("curricula.php?dipt=", "") }
          .map(&:to_i)
          .sort
      end

      def details(id)
        doc = parse(DETAILS_URL, id: id)

        profile = parse_profile(doc)
        career = parse_career(doc)

        {}.merge(profile, career)
      end

      def parse_profile(doc)
        name = doc.css("td.textocurrienc strong").first.text
        doc.css("td.textocurri").map { |n| n.text.strip }.each_slice(2).each_with_object({"Nombre" => name}) do |(title, value), acc|
          key = title.gsub(":", "")

          if key == "Entidad"
            entity, circuns, curul = value.gsub(/[\n ]/, "").split("|").map(&:strip)

            acc[key] = entity
            acc["Curul"] = curul
            circ_key, circ_value = circuns.split(":").map(&:strip)
            acc[circ_key] = circ_value.to_i
          else
            acc[key] = value
          end
        end
      end

      def parse_career(doc)
        current_category = ""
        current_record = {}
        current_col = 0

        doc.css("div.curricula").css("td.TitulosVerde,td.textoNegro").each_with_object({}) do |td, acc|
          if td.attr("class") == "TitulosVerde"
            acc.delete(current_category) if current_record.empty?

            current_col = 0
            current_record = {}
            current_category = td.text.titlecase

            acc[current_category] = [current_record]
          elsif td.attr("class") == "textoNegro"
            current_col = (current_col + 1) % 4

            if current_col == 0
              current_col = 1
              current_record = {}

              acc[current_category].append(current_record)
            end

            current_record[col_name(current_category, current_col)] = td.text.clean unless td.text.clean.empty?
          end
        end
      end

      def col_name(category, col)
        case category
        when "Administración Pública Federal"
          case col
          when 1 then "Puesto"
          when 2 then "Lugar"
          when 3 then "Periodo"
          end
        when "Administración Pública Local"
          case col
          when 1 then "Puesto"
          when 2 then "Lugar"
          when 3 then "Periodo"
          end
        when "Asociaciones a las que Pertenece"
          case col
          when 1 then "Posicion"
          when 2 then "Asociacion"
          when 3 then "Periodo"
          end
        when "Trayectoria Política"
          case col
          when 1 then "Cargo"
          when 2 then "Partido"
          when 3 then "Periodo"
          end
        when "Cargos de Elección Popular"
          case col
          when 1 then "Cargo"
          when 2 then "Partido"
          when 3 then "Periodo"
          end
        when "Escolaridad"
          case col
          when 1 then "Nivel de estudios"
          when 2 then "Titulo"
          when 3 then "Periodo"
          end
        when "Actividad Empresarial"
          case col
          when 1 then "Posicion"
          when 2 then "Empresa"
          when 3 then "Periodo"
          end
        when "Iniciativa Privada"
          case col
          when 1 then "Posicion"
          when 2 then "Empresa"
          when 3 then "Periodo"
          end
        when "Publicaciones"
          case col
          when 1 then "Titulo"
          when 2 then "Medio"
          when 3 then "Fecha"
          end
        when "Actividades Docentes"
          case col
          when 1 then "Puesto"
          when 2 then "Asignatura"
          when 3 then "Periodo"
          end
        when "Cargos en Legislaturas Locales o Federales"
          case col
          when 1 then "Cargo"
          when 2 then "Legislatura"
          when 3 then "Periodo"
          end
        when "Experiencia Legislativa"
          case col
          when 1 then "Cargo"
          when 2 then "Legislatura"
          when 3 then "Periodo"
          end
        else
          puts "[-] Unable to find col [#{col}] for category [#{category}]"
          col
        end
      end
    end
  end
end
