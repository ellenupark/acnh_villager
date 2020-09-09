class AcnhVillager::CLI
    @@list = []
    @@search_list = []

    def initialize
        AcnhVillager::API.scrape_villagers
        until @@list.length == 10
            random_villager = AcnhVillager::Villager.all[rand(1..AcnhVillager::Villager.all.count - 1)]
            @@list << random_villager if !@@list.include?(random_villager)
        end
    end

    def call
        puts "        ------------------------------------------------".colorize(:magenta)
        puts "       |                                                |".colorize(:magenta)
        puts "       |                 Animal Crossing                |".colorize(:magenta)
        puts "       |                  New Horizons                  |".colorize(:magenta)
        puts "       |                Villager Directory              |".colorize(:magenta)
        puts "       |                                                |".colorize(:magenta)
        puts "        ------------------------------------------------".colorize(:magenta)
        sleep(1)
        puts ""
        puts "Welcome to the Animal Crossing New Horizons Villager Directory!"
        sleep(1)
        list_villagers
        menu
    end

    def line
        puts "----------------------------------------------------------------"
    end

    def self.clear_search
        @@search_list.clear
    end

    def list_villagers
        puts ""
        puts "Listing featured villagers..."
        sleep (1)
        puts ""
        @@list.each.with_index(1) do | villager, i |
            puts "#{i}. #{villager.name}"
        end
    end

    def search_villagers
        puts "Please type the first letter of your desired villager's name."
        line
        input = gets.strip.downcase
        line
        sleep(1)

        if input == 'x'
            puts "Could not locate villager with name that begins with 'X'."
            search_villagers
        elsif input[/[a-z]\z/]  == input
            select_villager(input)
        elsif input == 'exit'
            goodbye
        else
            puts "Invalid input."
            search_villagers
        end
    end

    def select_villager(input)
        puts ""
        search_by_letter = AcnhVillager::Villager.all.select { | villager | villager.name[0].downcase == input }.sort_by{ | villager | villager.name }
        search_by_letter.each.with_index(1) do | villager, i |
            puts "#{i}. #{villager.name}"
            @@search_list << villager
        end

        puts ""
        puts "Select an above number to view villager details."
        puts "Type 'back' to search again or type 'menu' to return to main menu."
        line
        input_two = gets.strip.downcase
        sleep(1)
        if input_two.to_i.between?(1, @@search_list.count) 
            villager = @@search_list.find { | villager | villager.name == @@search_list[input_two.to_i - 1].name }
            display_villager_details(villager)
            AcnhVillager::CLI.clear_search
            sleep(1)
            search_again
        elsif input_two == 'menu'
            line
            sleep(1)
            list_villagers
            menu
        elsif input_two == 'back'
            search_villagers
        elsif input_two == 'exit'
            goodbye
        else
            line
            puts "Invalid input."
            line
            sleep(1)
            select_villager(input)
        end
    end

    def search_again
        puts "Type 'back' to search again or type 'menu' to return to main menu."
        line
        input = gets.strip.downcase
        line
        sleep(1)
        case input
        when "back"
            search_villagers
        when "menu"
            list_villagers
            menu
        when 'exit'
            goodbye
        else
            puts "Invalid input."
            search_again
        end
    end

    def menu
        puts ""
        puts "Select an above number to view villager details."
        puts "Type 'search' to look up a specific villager or type 'exit' to quit."
        line
        input = gets.strip.downcase
        line
        sleep(1)
        if input.to_i.between?(1, 10) 
            villager = AcnhVillager::Villager.all.find { | villager | villager.name == @@list[input.to_i - 1].name }
            display_villager_details(villager)
            sleep(1)
            restart
        elsif input == 'search'
            search_villagers
            line
            search_villagers
        elsif input == 'exit'
            goodbye
        else
            puts "Invalid input."
            line
            sleep(1)
            list_villagers
            menu
        end
    end

    def display_villager_details(villager)
        AcnhVillager::API.scrape_villager_details(villager)
        puts ""
        puts "Villager Information: ".colorize(:magenta) + "#{villager.name}:"
        puts ""
        puts "Japanese Name: ".colorize(:magenta) + "#{villager.jp_name}"
        puts "Personality: ".colorize(:magenta) + "#{villager.personality}"
        puts "Birthday: ".colorize(:magenta) + "#{villager.birthday}"
        puts "Species: ".colorize(:magenta) + "#{villager.species}"
        puts "Gender: ".colorize(:magenta) + "#{villager.gender}"
        puts "Hobby: ".colorize(:magenta) + "#{villager.hobby}"
        puts "Catch Phrase: ".colorize(:magenta) + "#{villager.catch_phrase}"
        puts "Favorite Saying: ".colorize(:magenta) + "#{villager.saying}"
        puts "Profile Picture: ".colorize(:magenta) + "#{villager.image_url}"
        puts ""
        line
    end

    def restart 
        puts "Type 'menu' to return to main menu or type 'exit' to quit."
        line
        input = gets.strip.downcase
        line
        sleep(1)
        case input
        when "menu"
            list_villagers
            menu
        when "exit"
            goodbye
        else
           puts "Invalid input."
           restart
        end
    end

    def goodbye
        puts ""
        puts "Thanks for visiting!".colorize(:magenta)
        puts ""
        line
        exit
    end
end