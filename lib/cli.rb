class CommandLineInterface

    def run
        create_teams
        create_players
        main_menu
    end


    def create_teams
        Teams.create_from_api
    end

    def create_players
        Players.create_from_api
    end

    def main_menu
        puts ""
        puts "Welcome to Baller Stats!"
        puts "Learn more about your favorite NBA players and their performance this season!"
        puts "To look up a player by team, type team."
        puts "To look up a player by their name, type name."
        puts "To quit this application, type exit at anytime."
        puts ""

        while input = gets.strip
            case input
            when "team"
                puts ""
                search_by_team
            when "name"
                puts ""
                search_by_name
            when "exit"
                exit
            else
                puts ""
                puts "Please enter a valid response"
                main_menu
            end
        end

    end

    def search_by_team
        team = nil
        tricodes = []
        player_numbers = []

        Teams.all.each {|team| 
            puts "#{team.tricode} - #{team.name}"
            tricodes << team.tricode
        }

        puts ""
        puts "Please select a team by typing the corresponding 3-character abbreviation."
        puts ""

        loop do
            input = gets.strip
            puts ""
            if tricodes.include?(input.upcase)
                Teams.all.each {|t| team = t if input.upcase == t.tricode}
                team.roster.each {|player| 
                puts "# #{player.number} - #{player.first_name} #{player.last_name}" if player.number != ""
                player_numbers << player.number if player.number != ""}
                break
            elsif input == "exit"
                exit
            else
                puts ""
                Teams.all.each {|team| puts "#{team.tricode} - #{team.name}"}
                puts ""
                puts "Please enter a valid response."
                puts ""
            end
        end
        
            
        puts ""
        puts "Please type a player number to obtain stats."
        puts ""
        loop do 
            input = gets.strip
            puts ""
            if player_numbers.include?(input)
                team.roster.each {|player| 
                if player.number == input
                    player.stats
                    puts ""
                    puts "Name: #{player.first_name} #{player.last_name}"
                    puts "Jersey: ##{player.number}"
                    puts "Team: #{player.team}"
                    puts "PPG: #{player.ppg}"
                    puts "RPB: #{player.rpg}"
                    puts "APG: #{player.apg}"
                    puts "TOPG: #{player.topg}"
                    puts "BPG: #{player.bpg}"
                    puts "SPG: #{player.spg}"
                    puts "FG: #{player.fgp}%"
                    puts "3PT: #{player.tpp}%"
                    puts "FT: #{player.ftp}%"
                    puts ""
                end}
                break
            elsif input == "exit"
                exit
            else
                puts ""
                team.roster.each {|player| puts "# #{player.number} - #{player.first_name} #{player.last_name}" if player.number != ""}
                puts ""
                puts "Please enter a valid response."
                puts ""
            end
        end
        puts "To start a new search, type main menu."
        puts "To quit this application, type exit"
        puts ""
        loop do
        input = gets.strip
        puts ""
            if input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                puts ""
                puts "To start a new search, type main menu."
                puts "To quit this application, type exit"
                puts "Please enter a valid response."
                puts ""
            end
        end
    end

    def search_by_name
    end




end