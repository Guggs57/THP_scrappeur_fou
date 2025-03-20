require 'nokogiri'
require 'open-uri'
require_relative 'votre_fichier'  # Remplacez 'votre_fichier' par le nom de votre fichier Ruby

RSpec.describe 'CryptoScraper' do
  describe '#url' do
    it 'devrait renvoyer une page Nokogiri pour une page valide' do
      page = url(1)
      expect(page).to be_an_instance_of(Nokogiri::HTML::Document)
    end

    it 'devrait gérer les erreurs d\'accès à la page' do
      allow(URI).to receive(:open).and_raise(OpenURI::HTTPError.new('404 Not Found', nil))
      expect(url(999)).to be_nil
    end
  end

  describe '#crypto_name' do
    it 'devrait retourner une liste de noms de cryptomonnaies' do
      allow(self).to receive(:url).and_return(Nokogiri::HTML('<html><body><tr class="cmc-table-row"><td></td><td>Bitcoin</td></tr></body></html>'))
      names = crypto_name
      expect(names).to include('Bitcoin')
    end

    it 'devrait ne pas inclure des noms vides' do
      allow(self).to receive(:url).and_return(Nokogiri::HTML('<html><body><tr class="cmc-table-row"><td></td><td></td></tr></body></html>'))
      names = crypto_name
      expect(names).to be_empty
    end
  end

  describe '#crypto_price' do
    it 'devrait retourner une liste de prix de cryptomonnaies' do
      allow(self).to receive(:url).and_return(Nokogiri::HTML('<html><body><tr class="cmc-table-row"><td></td><td></td><td></td><td>50000</td></tr></body></html>'))
      prices = crypto_price
      expect(prices).to include('50000')
    end

    it 'devrait ne pas inclure des prix vides' do
      allow(self).to receive(:url).and_return(Nokogiri::HTML('<html><body><tr class="cmc-table-row"><td></td><td></td><td></td><td></td></tr></body></html>'))
      prices = crypto_price
      expect(prices).to be_empty
    end
  end

  describe '#big_hash' do
    it 'devrait créer un hash avec les noms de cryptos et leurs prix' do
      allow(self).to receive(:crypto_name).and_return(['Bitcoin', 'Ethereum'])
      allow(self).to receive(:crypto_price).and_return(['50000', '4000'])
      result = big_hash
      expect(result).to eq({'Bitcoin' => '50000', 'Ethereum' => '4000'})
    end

    it 'devrait renvoyer un hash vide si les noms ou les prix
