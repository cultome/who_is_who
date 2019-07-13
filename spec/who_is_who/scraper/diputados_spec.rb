RSpec.describe WhoIsWho::Scraper::Diputados do
  let(:scraper) { WhoIsWho::Scraper::Diputados.new }

  it 'get the diputados name and ID' do
    expect(scraper).to receive(:fetch).and_return(url_content('lista_diputados'))
    expect(scraper.ids.size).to eq 499
  end
end
