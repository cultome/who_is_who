RSpec.describe WhoIsWho::Scraper::Diputados do
  let(:scraper) { WhoIsWho::Scraper::Diputados.new }

  it 'get the diputados name and ID' do
    expect(scraper)
      .to receive(:fetch)
      .with(WhoIsWho::Scraper::Diputados::LIST_URL)
      .and_return(url_content('lista_diputados'))
    expect(scraper.ids.size).to eq 499
  end

  context 'get the details for a diputado' do
    it 'diputado_1' do
      expect(scraper)
        .to receive(:fetch)
        .with(WhoIsWho::Scraper::Diputados::DETAILS_URL.gsub('<id>', '111'))
        .and_return(url_content('detalles_diputado_1'))

      response = {
        'Administración Pública Local' => [
          { 'Lugar' => 'H. Ayuntamiento de Nezahualcóyotl', 'Periodo' => '2009-2012', 'Puesto' => 'Asesor 18 Regidor' },
          { 'Lugar' => 'H. Ayuntamiento de Nezahualcóyotl', 'Periodo' => '2012-2015', 'Puesto' => 'Asesor 18 Regidor' }
        ],
        'Escolaridad' => [
          { 'Nivel de estudios' => 'Secundaria', 'Periodo' => '2001-2003', 'Titulo' => 'Operador en Microcomputadoras' }
        ]
      }
      expect(scraper.details(111)).to eq response
    end

    it 'diputado_2' do
      expect(scraper)
        .to receive(:fetch)
        .with(WhoIsWho::Scraper::Diputados::DETAILS_URL.gsub('<id>', '222'))
        .and_return(url_content('detalles_diputado_2'))

      response = {
        'Asociaciones a las que Pertenece' => [
          { 'Asociacion' => 'Mexicana de Mujeres Jefas de Empresas, A. C. AMMJE', 'Posicion' => 'No proporcionó' }
        ],
        'Cargos de Elección Popular' => [
          { 'Cargo' => 'Síndico(a), México - Texcoco', 'Partido' => 'MORENA', 'Periodo' => '2016 -2018' }
        ],
        'Escolaridad' => [
          { 'Nivel de estudios' => 'Licenciatura', 'Periodo' => '1992 - 1997', 'Titulo' => 'Relaciones Internacionales' },
          { 'Nivel de estudios' => 'Diplomado', 'Titulo' => 'Ciencias Políticas' }
        ],
        'Iniciativa Privada' => [
          { 'Empresa' => 'Coca Cola FEMSA', 'Periodo' => '1999 - 2000', 'Posicion' => 'Analista de Gerencia' },
          { 'Empresa' => 'Comercializadora Arte ventas', 'Periodo' => '2003 - 2005', 'Posicion' => 'Gerente de Ventas' },
          { 'Empresa' => 'Cadena Comercial Oxxo', 'Periodo' => '2006 - 2008', 'Posicion' => 'Encargada de Expansión' }
        ],
        'Publicaciones' => [
          { 'Fecha' => '2018', 'Medio' => 'Revista', 'Titulo' => 'Pensamiento y Reflexión' },
          { 'Fecha' => '2018', 'Medio' => 'Revista', 'Titulo' => 'Ejes diacrónicos y derivas conceptuales de la Pobreza' }
        ]
      }
      expect(scraper.details(222)).to eq response
    end

    it 'diputado_3' do
      expect(scraper)
        .to receive(:fetch)
        .with(WhoIsWho::Scraper::Diputados::DETAILS_URL.gsub('<id>', '333'))
        .and_return(url_content('detalles_diputado_3'))

      response = {
        'Administración Pública Local' => [
          { 'Lugar' => 'Instituto de las Mujeres del D.F.', 'Periodo' => '2001-2003', 'Puesto' => 'Lider coordinador de proyectos' },
          { 'Lugar' => 'Instituto Electoral del D.F.', 'Periodo' => '2007-2008', 'Puesto' => 'Lider coordinador de proyectos' },
          { 'Lugar' => 'Delegación Tláhuac', 'Periodo' => '2012-2014', 'Puesto' => 'Subdirectora Jurídica' }
        ],
        'Asociaciones a las que Pertenece' => [
          { 'Asociacion' => 'Unidos por el Bienestar Social A.C.', 'Periodo' => '2007-2017', 'Posicion' => 'Presidenta' }
        ],
        'Escolaridad' => [
          { 'Nivel de estudios' => 'Posgrado', 'Periodo' => '2009-2011', 'Titulo' => 'Alta Dirección' },
          { 'Nivel de estudios' => 'Licenciatura', 'Periodo' => '1993-1997', 'Titulo' => 'Derecho' }
        ],
        'Trayectoria Política' => [
          { 'Cargo' => 'Congresista Nacional', 'Partido' => 'Izquierda', 'Periodo' => '2001' },
          { 'Cargo' => 'Representante Federal', 'Partido' => 'Izquierda', 'Periodo' => '2005-2006' },
          { 'Cargo' => 'Secretaria de Formación Política', 'Partido' => 'Izquierda', 'Periodo' => '2009-2012' },
          { 'Cargo' => 'Consejera Estatal', 'Partido' => 'Izquierda', 'Periodo' => '2012-2015' },
          { 'Cargo' => 'Comisión MORENA', 'Partido' => 'MORENA', 'Periodo' => '2016-2017' }
        ],
      }
      expect(scraper.details(333)).to eq response
    end

    it 'diputado_5' do
      expect(scraper)
        .to receive(:fetch)
        .with(WhoIsWho::Scraper::Diputados::DETAILS_URL.gsub('<id>', '555'))
        .and_return(url_content('detalles_diputado_5'))

      response = {
        'Administración Pública Local' => [
          { 'Lugar' => 'Secretaría General de Gobierno del estado de Oaxaca', 'Periodo' => '2011-2012', 'Puesto' => 'Director de Gobierno' }
        ],
        'Cargos en Legislaturas Locales o Federales' => [
          {'Cargo' => 'Coordinador de la fracción parlamentaria de Morena, Congreso del estado de Oaxaca', 'Legislatura' => 'LXIII Legislatura' },
          {'Cargo' => 'Presidente de la Junta de Coordinación Política, Congreso del estado de Oaxaca', 'Legislatura' => 'LXIII Legislatura' }
        ],
        'Cargos de Elección Popular' => [
          { 'Cargo' => 'Presidente Municipal, Oaxaca - San José Chiltepec', 'Partido' => 'Convergencia', 'Periodo' => '2008-2010' },
          { 'Cargo' => 'Presidente Municipal, Oaxaca - San José Chiltepec', 'Partido' => 'MC', 'Periodo' => '2014-2016' }
        ],
        'Escolaridad' => [
          { 'Nivel de estudios' => 'Licenciatura', 'Periodo' => '2004-2008', 'Titulo' => 'Informática' }
        ],
        'Experiencia Legislativa' => [
          { 'Cargo' => 'Diputada(o) Local Propietario, Morena', 'Legislatura' => 'LXIII Legislatura', 'Periodo' => '2016-2018' }
        ],
        'Iniciativa Privada' => [
          { 'Empresa' => 'Grupo Gomsa, Veracruz', 'Periodo' => '1999-2004', 'Posicion' => 'Jefe de Sistemas' },
          { 'Empresa' => 'PROTEXA', 'Periodo' => '2004-2005', 'Posicion' => 'Jefe de Sistemas' },
          { 'Empresa' => 'Gerencia de Ingeniería y Construcción, Región Marina Noroeste PEMEX, en Ciudad del Carmen, Campeche', 'Periodo' => '2005-2007', 'Posicion' => 'Control de obra' }
        ],
        'Trayectoria Política' => [
          { 'Cargo' => 'Coordinador de Giras de Campaña del Senador por Oaxaca de la coalición Movimiento Progresista', 'Partido' => 'MORENA', 'Periodo' => '2012' }
        ]
      }
      expect(scraper.details(555)).to eq response
    end
  end
end
