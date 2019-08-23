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

      def personal_information(id)
        doc = parse(DETAILS_URL, id: id)

        profile = parse_profile(doc)
        career = parse_career(doc)

        {}.merge(profile, career)
      end

      def work_information(id)
        doc = parse(DETAILS_URL, id: id)

        commissions = parse_commissions(doc)
        initiatives = parse_initiatives(doc)
        propositions = parse_propositions(doc)
        votations = parse_votations(doc)
        assistance = parse_assistance(doc)

        {
          commissions: commissions,
          initiatives: initiatives,
          propositions: propositions,
          assistance: assistance,
          votations: votations,
        }
      end

      def parse_votations(doc)
        # TODO: implement
        {}
      end

      def parse_assistance(doc)
        # TODO: implement
        {}
      end

      def parse_propositions(doc)
        doc.css("div.comision td.Estilo69").each_slice(5).map do |(text, turn_to, proposed, approved, tramite)|
          initiative = text.children.first.children.last.text.clean

          type = text.css("span.Estilo71").last.children.first.text.gsub(": ", "")
          #type_value = text.css("span.Estilo71").last.children.last.text

          date = turn_to.children.first.text.split(":").last.clean
          turn_to_comm = turn_to.css("b").last.text

          proposed_text = proposed.children.first.children.map(&:text).map(&:clean).delete_if(&:empty?).join("\n")
          approved_text = approved.children.first.children.map(&:text).map(&:clean).delete_if(&:empty?).join("\n")

          status = tramite.children.first.children.first.text
          status_date = tramite.children.first.children[-2].text.clean

          {
            "Proposicion" => initiative,
            "Tipo de proposicion" => type,
            "Fecha de presentacion" => date,
            "Turnado a comision" => turn_to_comm,
            "Resolutivos del proponente" => proposed_text,
            "Resolutivos aprobados" => approved_text,
            "Tramite en el pleno" => status,
            "Fecha de tramite" => status_date,
          }
        end
      end

      def parse_initiatives(doc)
        doc.css("div.iniciativas td.Estilo69").each_slice(4).map do |(text, turn_to, sinopsis, tramite)|
          initiative = text.children.first.children.last.text.clean

          type = text.css("span.Estilo71").last.children.first.text.gsub(": ", "")
          #type_value = text.css("span.Estilo71").last.children.last.text

          date = turn_to.children.first.text.split(":").last.clean
          turn_to_comm = turn_to.css("b").last.text
          resume = sinopsis.children.first.children.map(&:text).map(&:clean).delete_if(&:empty?).join("\n")

          status = tramite.children.first.children.first.text
          status_date = tramite.children.first.children[-2].text.clean

          {
            "Iniciativa" => initiative,
            "Tipo de Iniciativa" => type,
            "Fecha de presentacion" => date,
            "Turnado a comision" => turn_to_comm,
            "Sinopsis" => resume,
            "Tramite en el pleno" => status,
            "Fecha de tramite" => status_date,
          }
        end
      end

      def parse_commissions(doc)
        doc.css("a.linkNegroSin").map do |link|
          link["href"] =~ /comt=([\d]+)$/

          { "Nombre" => link.text.clean, "id" => $1.to_i }
        end
      end

      def parse_profile(doc)
        name = doc.css("td.textocurrienc strong").first.text
        doc.css("td.textocurri").map { |n| n.text.clean }.each_slice(2).each_with_object({"Nombre" => name}) do |(title, value), acc|
          key = title.gsub(":", "")

          if key == "Entidad"
            entity, circuns, curul = value.gsub(/[\n ]/, "").split("|").map(&:clean)

            acc[key] = entity
            acc["Curul"] = curul
            circ_key, circ_value = circuns.split(":").map(&:clean)
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
