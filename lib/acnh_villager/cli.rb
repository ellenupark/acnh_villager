class AcnhVillager::CLI
    @@list = []
    @@search_list = []

    def initialize
        AcnhVillager::API.scrape_villagers
        until @@list.length == 10
            villager = AcnhVillager::Villager.generate_random_villager
            @@list << villager if !@@list.include?(villager)
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
        list_featured_villagers
        menu
    end

    def list_featured_villagers
        puts ""
        puts "Listing Today's Featured Villagers..."
        sleep (1)
        puts ""
        @@list.each.with_index(1) do | villager, i |
            puts "#{i}. #{villager.name}"
        end
    end

    def find_and_display_villager(villager_list, input)
        display_villager_details(villager_list.find { | villager | villager == villager_list[input.to_i - 1] })
    end

    def menu
        puts ""
        puts "Select an above number to view villager details."
        puts "Type 'search' to look up a specific villager or type 'exit' to quit."
        line
        user_input = gets.strip.downcase
        line
        sleep(1)
        if user_input.to_i.between?(1, 10) 
            find_and_display_villager(@@list, user_input)
            restart
        elsif user_input == 'search'
            search_by_name
            line
        elsif user_input == 'exit'
            goodbye
        else
            puts "Invalid input."
            line
            sleep(1)
            list_featured_villagers
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

    def line
        puts "----------------------------------------------------------------"
    end

    def restart 
        puts "Type 'menu' to return to main menu or type 'exit' to quit."
        line
        user_input = gets.strip.downcase
        line
        sleep(1)
        case user_input
        when "menu"
            list_featured_villagers
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
        puts "   _      _      _ ".colorize(:magenta)
        puts "__(.)< __(.)> __(.)=".colorize(:magenta)
        puts "\\___)  \\___)  \\___)".colorize(:magenta)
        puts ""
        puts "Thanks for visiting!".colorize(:cyan)
        puts "  _      _      _".colorize(:magenta)
        puts ">(.)__ <(.)__ =(.)__".colorize(:magenta)
        puts " (___/  (___/  (___/".colorize(:magenta)
        puts ""
        line
        exit
    end

    # SEARCH FUNCTION   

    def search_by_name
        puts "Please type the first letter of your desired villager's name."
        line
        first_letter = gets.strip.downcase
        line
        sleep(1)

        if first_letter == 'x'
            puts "Could not locate villager with name that begins with 'X'."
            search_by_name
        elsif first_letter[/[a-z]\z/]  == first_letter
            list_searched_villagers(first_letter)
        elsif first_letter == 'exit'
            goodbye
        else
            puts "Invalid input."
            search_by_name
        end
    end

    def list_searched_villagers(first_letter)
        puts ""
        AcnhVillager::Villager.search_villagers_by_name(first_letter).each.with_index(1) do | villager, i |
            puts "#{i}. #{villager.name}"
            @@search_list << villager
        end
        puts ""
        puts "Select an above number to view villager details."
        select_searched_villager(first_letter)
    end

    def select_searched_villager(first_letter=nil)
        puts "Type 'back' to search again or type 'menu' to return to main menu."
        line
        user_input = gets.strip.downcase
        line
        sleep(1)
        if user_input.to_i.between?(1, @@search_list.count) 
            find_and_display_villager(@@search_list, user_input)
            AcnhVillager::CLI.clear_search_list
            sleep(1)
            select_searched_villager
        elsif user_input == 'menu'
            AcnhVillager::CLI.clear_search_list
            sleep(1)
            list_featured_villagers
            menu
        elsif user_input == 'back'
            AcnhVillager::CLI.clear_search_list
            search_by_name
        elsif user_input == 'exit'
            goodbye
        else
            puts "Invalid input."
            if first_letter # When user has not yet selected a villager to view
                AcnhVillager::CLI.clear_search_list
                line
                sleep(1)
                list_searched_villagers(first_letter)
            else # When user is viewing villager details
                select_searched_villager 
            end
        end
    end

    def self.clear_search_list
        @@search_list.clear
    end
end