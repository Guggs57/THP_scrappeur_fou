require_relative '../lib/01_mairie'



describe "open_page(town_url) function" do
  it "returns a Nokogiri::HTML4::Document" do
    expect(open_page(town_url1).nil?).to eq(false)
    expect(open_page(town_url1).class).to eq(Nokogiri::HTML4::Document)
  end
end

describe "get_townhall_email(town_url) function" do
  it "returns a hash {name => email}" do
    expect(get_townhall_email(town_url1)).to eq({ "AVERNES" => "mairie.avernes@orange.fr" })
    expect(get_townhall_email(town_url2)).to eq({ "MONTAUBAN-DE-BRETAGNE" => "accueil@mairie-montaubandebretagne.fr" })
  end
end

describe "get_townhall_urls(departement_url, main_url) function" do
  it "returns an array of town hashes [{name1 => url1},{name2 => url2}]" do
    expect(get_townhall_urls(url_depart1, main_url).first).to eq({ "ABLEIGES" => "https://annuaire-des-mairies.com/95/ableiges.html" })
    expect(get_townhall_urls(url_depart1, main_url).length > 10).to eq(true)
  end
end

describe "townhall_scrapper(departement_url, site_url) function" do
  it "returns an array of town hashes [{name1 => email1},{name2 => email2}]" do
    expect(townhall_scrapper(url_depart1, main_url).first).to eq({ "ABLEIGES" => "mairie.ableiges95@wanadoo.fr" })
    expect(townhall_scrapper(url_depart1, main_url).length > 10).to eq(true)
  end
end