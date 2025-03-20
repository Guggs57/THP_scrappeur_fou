# frozen_string_literal: true

# Gem PRY : outil de débogage
require 'pry'  # Appelle la gem Pry : use binding.pry
# Gem Nokogiri : scraping
require 'nokogiri'
# Gem open-uri : ouvrir une URL
require 'open-uri'
require 'uri'


base_url = "https://coinmarketcap.com/all/views/all/"
 

def get_price_crypto(base_url)
  
 
    page = Nokogiri::HTML(URI.open(base_url))
  name_crypto = page.xpath('//a[@class="cmc-table__column-name--name cmc-link"]')
  price_crypto = page.xpath('//div[contains(@class, "sc-142c02c-0 lmjbLF")]//span')
    
    final_tabl = []
    tabl_price = []
    tabl_name =  []
    

      price_crypto.each do |i|
        tabl_price << i.text 
      end

      name_crypto.each do |i|
        tabl_name << i.text
      end 

  
      tabl_name.each.with_index do |name, index|  
        my_hash = Hash.new #Declare un nouveau Hash
        my_hash[name] = tabl_price[index]  #Insere dans le Hash le nom et le prix de tab_price
      

        final_tabl << my_hash
end
  puts final_tabl
    end


get_price_crypto(base_url)
