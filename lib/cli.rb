class CommandLineInterface

    def run
        Teams.create_from_api
        Players.create_from_api
        main_menu
    end

    def main_menu
        puts "\nWelcome to Been Ballin? Statistics!"
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

    def list_teams
        Teams.all.each {|team| 
            print "#{team.tricode}".bold 
            puts " - #{team.name}"
        }
    end

    def list_roster(team)
        puts
        puts "#{team.name}".underline
        puts
        team.roster.each {|player| 
            if player.number != ""
                print "#{player.number}".bold
                puts" - #{player.first_name} #{player.last_name}"
            end
        }
    end

    def list_stats(player)
        player.get_stats
        puts "\nName: #{player.first_name} #{player.last_name}"
        puts "Team: #{player.team.name}"
        puts "Jersey: ##{player.number}" if player.number != ""
        puts "Position: #{player.position}" if player.position != ""
        puts "Age: #{player.age}" if player.dob != ""
        puts "Height: #{player.height}" if player.height != "-\'-\" - m"
        puts "Weight: #{player.weight}" if player.weight != "lbs - kg"
        puts "PPG: #{player.ppg}" if player.ppg
        puts "RPB: #{player.rpg}" if player.rpg
        puts "APG: #{player.apg}" if player.apg
        puts "TOPG: #{player.topg}" if player.topg
        puts "BPG: #{player.bpg}" if player.bpg
        puts "SPG: #{player.spg}" if player.spg 
        puts "FG: #{player.fgp}%" if player.fgp
        puts "3PT: #{player.tpp}%" if player.tpp
        puts "FT: #{player.ftp}%" if player.ftp
    end

    def search_by_team
        team = nil
        tricodes = []
        player_numbers = []
        Teams.all.each {|team| tricodes << team.tricode}
        list_teams
        puts "\nPlease select a team by typing the corresponding 3-character abbreviation.\n "
        loop do
            input = gets.strip
            if tricodes.include?(input.upcase)
                Teams.all.each {|t| team = t if input.upcase == t.tricode}
                team.roster.each {|player| player_numbers << player.number if player.number != ""}
                list_roster(team)
                break
            elsif input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                puts
                list_teams
                invalid_input
            end
        end
        puts "\nPlease enter a player's number to obtain stats.\n "
        loop do
            input = gets.strip
            if player_numbers.include?(input)
                team.roster.each {|player| 
                if player.number == input
                    list_stats(player)
                end}
                break
            elsif input == "main menu"
                main_menu
            elsif input == "exit"
                exit
            else
                list_roster(team)
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
                list_stats(player)
                break
            elsif close_matches.length == 1
                player = close_matches[0]
                list_stats(player)
                break
            elsif close_matches.length > 0
                puts
                close_matches.each_with_index {|player, index| 
                    print "#{index+1}".bold 
                    puts " - #{player.first_name} #{player.last_name} - #{player.team.tricode}"}
                puts "\nPlease select desired player by typing in search result number.\n "
                loop do
                    input = gets.strip
                    number = input.to_i
                    num_of_results = close_matches.length
                    results = Array(1..num_of_results)
                    if results.include?(number)
                        player = close_matches[number-1]
                        list_stats(player)
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
