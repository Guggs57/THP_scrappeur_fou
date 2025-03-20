# frozen_string_literal: true

# Gem PRY : outil de débogage
require 'pry'  # Appelle la gem Pry : use binding.pry
# Gem Nokogiri : scraping
require 'nokogiri'
# Gem open-uri : ouvrir une URL
require 'open-uri'
require 'uri'

def get_townhall_urls
  townhall_url = []  # Définir la variable ici
  base_url = "https://lannuaire.service-public.fr/navigation/ile-de-france/val-d-oise/mairie"
  chiffre = 0

  10.times do |i|
    chiffre += 1
    base_url_page = base_url + "?page=#{chiffre}"
    puts base_url_page

    # Charger la page d'annuaire des mairies
    page = Nokogiri::HTML(URI.open(base_url_page))
    liens = page.xpath('//a[@class="fr-link"]')

    # Extraire les URLs des mairies
    liens.each do |nom|
      relative_url = nom['href']

      # Vérifier si le lien est déjà absolu ou relatif
      if relative_url.start_with?("http")
        # Si c'est déjà un lien absolu, on le garde tel quel
        townhall_url << relative_url
    end
  end
end


  return townhall_url  # Renvoyer la liste des URLs collectées
end

def get_townhall_email(townhall_url)
  townhall_email = []  # Définir ici la variable pour stocker les emails
  townhall_name = []   # Définir ici la variable pour stocker les noms des mairies

    townhall_url.each do |url|
      begin
        page_mairie = Nokogiri::HTML(URI.open(url))
        
        # Récupérer le nom de la mairie
        name_mairie = page_mairie.xpath('//h1[@id="titlePage"]').text.strip
        
        # Récupérer l'email si disponible
        email_mairie = page_mairie.xpath('//a[@class="send-mail"]').text.strip

        # Ajouter le nom de la mairie et l'email dans les tableaux
        townhall_name << name_mairie
        townhall_email << email_mairie
      rescue OpenURI::HTTPError => e
        # Gérer les erreurs liées à l'ouverture des pages
        puts "Erreur lors de l'ouverture de la page : #{url} - #{e.message}"
      end
    end

    # Créer un tableau de hachages avec les noms et les emails
    result = townhall_name.zip(townhall_email).map { |nom, email| { nom => email } }

    puts "Résultats :"
    result.each do |entry|
      entry.each do |name, email|
        # Afficher le nom de la mairie et de l'email
        if email == nil
          puts "#{name} "
        else
          puts "#{name}: #{email}"
        end
      end
    end
end

# Appeler les fonctions dans le bon ordre
townhall_urls = get_townhall_urls  # Récupérer les URLs des mairies
get_townhall_email(townhall_urls)  # Passer les URLs récupérées pour obtenir les emails
