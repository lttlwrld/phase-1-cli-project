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
        puts "\nWelcome to Been Ballin' Statistics!"
        puts "Learn more about your favorite NBA players and their performance this season!"
        puts "To look up a player by team, type team."
        puts "To look up a player by name, type name."
        puts "To return to the main menu at any time, type main menu"
        puts "To exit this application at any time, type exit.\n "
        input = gets.strip
        case input
        when "team"
            puts
            search_by_team
        when "teams"
            puts
            search_by_team
        when "name"
            search_by_name
        when "exit"
            exit
        when "main menu"
            main_menu
        else
            puts "\nPlease enter a valid response.".red
            main_menu
        end
    end

    def invalid_input
        puts "\nPlease enter a valid response.\n ".red
        puts "To start a new search, type main menu."
        puts "To exit this application, type exit\n "
    end

    def search_complete
        puts "\nTo start a new search, type main menu."
        puts "To exit this application, type exit.\n "
        loop do
            input = gets.strip
            case input
            when "main menu"
                main_menu
            when "exit"
                exit
            else
                invalid_input
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

        puts "\nPlease select a team by typing the corresponding 3-character abbreviation.\n "
        loop do
            input = gets.strip
            if tricodes.include?(input.upcase)
                puts
                Teams.all.each {|t| team = t if input.upcase == t.tricode}
                puts "#{team.name}\n "
                team.roster.each {|player| 
                puts "# #{player.number} - #{player.first_name} #{player.last_name}" if player.number != ""
                player_numbers << player.number if player.number != ""}
                break
            elsif input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                puts
                Teams.all.each {|team| puts "#{team.tricode} - #{team.name}"}
                invalid_input
            end
        end
        puts "\nPlease enter a player's number to obtain stats.\n "
        loop do
            input = gets.strip
            if player_numbers.include?(input)
                team.roster.each {|player| 
                if player.number == input
                    player.stats
                end}
                break
            elsif input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                team.roster.each {|player| puts "# #{player.number} - #{player.first_name} #{player.last_name}" if player.number != ""}
                invalid_input
            end
        end
        search_complete
    end

    def search_by_name
        puts "\nPlease enter player's name.\n "
        loop do
            input = gets.strip
            search = input.upcase.split(" ")
            exact_match = Players.all.select {|player| 
            [player.first_name.upcase, player.last_name.upcase].include?(search[0]) && [player.first_name.upcase, player.last_name.upcase].include?(search[1])
            }
            close_matches = Players.all.select {|player| 
                [player.first_name.upcase, player.last_name.upcase].include?(search[0]) || [player.first_name.upcase, player.last_name.upcase].include?(search[1])
                }
            if exact_match.length == 1
                player = exact_match[0]
                player.stats
                break
            elsif close_matches.length == 1
                player = close_matches[0]
                player.stats
                break
            elsif close_matches.length > 0
                puts
                close_matches.each_with_index {|player, index| puts "#{index+1}. #{player.first_name} #{player.last_name} - #{player.team.tricode}"}
                puts "\nPlease select desired player by typing in search result number.\n "
                loop do
                    input = gets.strip
                    number = input.to_i
                    num_of_results = close_matches.length
                    results = Array(1..num_of_results)
                    if results.include?(number)
                        player = close_matches[number-1]
                        player.stats
                        break
                    elsif input == "main menu"
                        main_menu
                    elsif input == "exit"
                        exit
                    else 
                        invalid_input
                    end
                end
                break
            elsif input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                puts "\nNo results for #{input}".red
                search_by_name
            end
        end
        search_complete
    end

end