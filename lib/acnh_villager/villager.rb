class AcnhVillager::Villager
    @@all = []
  
    attr_accessor :url, :name, :jp_name, :personality, :birthday, :species, :gender, :hobby, :catch_phrase, :image_url, :saying
  
    def initialize(villager)
        self.name = villager[:name][:'name-USen']
        self.url = "http://acnhapi.com/v1/villagers/#{villager[:id].to_s}" 
        @@all << self
    end
  
    def self.all
        @@all
    end
end