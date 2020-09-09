class AcnhVillager::API

    def self.scrape_villagers
        resp = RestClient.get('http://acnhapi.com/v1/villagers/')
        villager_hash = JSON.parse(resp.body, symbolize_names:true) 
        villager_hash.each do | k, v | 
            AcnhVillager::Villager.new(villager_hash[k]) 
        end
    end

    def self.scrape_villager_details(villager)
        resp = RestClient.get(villager.url)
        villager_hash = JSON.parse(resp.body, symbolize_names:true) 
        villager.jp_name = villager_hash[:name][:"name-JPja"]
        villager.personality = villager_hash[:personality]
        villager.birthday = villager_hash[:'birthday-string']
        villager.species = villager_hash[:species]
        villager.gender = villager_hash[:gender]
        villager.hobby = villager_hash[:hobby]
        villager.catch_phrase = villager_hash[:"catch-phrase"]
        villager.image_url = villager_hash[:image_uri]
        villager.saying = villager_hash[:saying]
    end

end