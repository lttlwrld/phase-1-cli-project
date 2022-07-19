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
        puts "Welcome to Been Ballin' Statistics!"
        puts "Learn more about your favorite NBA players and their performance this season!"
        puts "To look up a player by team, type team."
        puts "To look up a player by name, type name."
        puts "To return to the main menu at any time, type main menu"
        puts "To exit this application at any time, type exit."
        puts ""
        input = gets.strip
        case input
        when "team"
            puts ""
            search_by_team
        when "teams"
            puts ""
            search_by_team
        when "name"
            puts ""
            search_by_name
        when "exit"
            exit
        when "main menu"
            main_menu
        else
            puts ""
            puts "Please enter a valid response."
            main_menu
        end
    end

    def print_stats(player)
        player.stats
        puts "Name: #{player.first_name} #{player.last_name}"
        puts "Team: #{player.team.name}"
        puts "Jersey: ##{player.number}"
        puts "Height: #{player.height}"
        puts "Weight: #{player.weight}"
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
            elsif input == "main menu"
                main_menu
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
                    print_stats(player)
                end}
                break
            elsif input == "main menu"
                main_menu
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
        puts "To exit this application, type exit."
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
                puts "Please enter a valid response."
                puts ""
                puts "To start a new search, type main menu."
                puts "To exit this application, type exit"
                puts ""
            end
        end
    end

    def search_by_name
        puts ""
        puts "Please enter player's name."
        puts ""
        loop do
            input = gets.strip
            puts ""
            search = input.upcase.split(" ")
            exact_match = Players.all.select {|player| 
            [player.first_name.upcase, player.last_name.upcase].include?(search[0]) && [player.first_name.upcase, player.last_name.upcase].include?(search[1])
            }
            close_matches = Players.all.select {|player| 
                [player.first_name.upcase, player.last_name.upcase].include?(search[0]) || [player.first_name.upcase, player.last_name.upcase].include?(search[1])
                }
            if exact_match.length == 1
                player = exact_match[0]
                print_stats(player)
                break
            elsif close_matches.length == 1
                player = close_matches[0]
                print_stats(player)
                break
            elsif close_matches.length > 0
                close_matches.each_with_index {|player, index| puts "#{index+1}. #{player.first_name} #{player.last_name} - #{player.team.tricode}"}
                puts ""
                puts "Please select desired player by typing in search result number."
                loop do
                    input = gets.strip
                    number = input.to_i
                    num_of_results = close_matches.length
                    puts ""
                    results = Array(1..num_of_results)
                    if results.include?(number)
                        player = close_matches[number-1]
                        print_stats(player)
                        break
                    elsif input == "main menu"
                        main_menu
                    elsif input == "exit"
                        exit
                    else 
                        puts ""
                        puts "Please enter a valid response."
                        puts ""
                    end
                end
                break
            elsif input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                puts ""
                puts "No results. Please try again."
                puts ""
            end
        end
        puts "To start a new search, type main menu."
        puts "To exit this application, type exit."
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
                puts "Please enter a valid response."
                puts ""
                puts "To start a new search, type main menu."
                puts "To exit this application, type exit"
                puts ""
            end
        end
    end

end