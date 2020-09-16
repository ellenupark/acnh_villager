class AcnhVillager::Villager
    @@all = []
  
    attr_accessor :url, :name, :jp_name, :personality, :birthday, :species, :gender, :hobby, :catch_phrase, :image_url, :saying
  
    def initialize(villager)
        @name = villager[:name][:'name-USen']
        @url = "http://acnhapi.com/v1/villagers/#{villager[:id].to_s}" 
        @@all << self
    end
  
    def self.all
        @@all
    end

    def self.generate_random_villager
        @@all[rand(1..AcnhVillager::Villager.all.count - 1)]
    end

    def self.search_villagers_by_name(first_letter_of_name)
        @@all.select { | villager | villager.name[0].downcase == first_letter_of_name }.sort_by{ | villager | villager.name }
    end 
end