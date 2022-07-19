class Players

    attr_reader :first_name, :last_name, :player_id, :team_id, :team, :number, :weight, :height, :ppg, :rpg, :apg, :topg, :bpg, :spg, :fgp, :tpp, :ftp 

    @@all = []

    def initialize(player_hash)
        @first_name = player_hash["firstName"]
        @last_name = player_hash["lastName"]
        @player_id = player_hash["personId"]
        @team_id = player_hash["teamId"]
        Teams.all.each do |team| 
            @team = team.name if team.team_id == @team_id
            team.roster << self if team.team_id == @team_id
        end
        @number = player_hash["jersey"] 
        @height = "#{player_hash["heightFeet"]}\'#{player_hash["heightInches"]}\"  -  #{player_hash["heightMeters"]}m" 
        @weight = "#{player_hash["weightPounds"]}lbs  - #{player_hash["weightKilograms"]}kg"
        @@all << self
    end

    def self.create_from_api
        players = Scraper.get_players
        players.each {|player| Players.new(player)}
    end

    def stats
        stats_hash = Scraper.get_player_stats(@player_id)
        if stats_hash != []
            @ppg = stats_hash[0]["total"]["ppg"]
            @rpg = stats_hash[0]["total"]["rpg"]
            @apg = stats_hash[0]["total"]["apg"]
            @topg = stats_hash[0]["total"]["topg"]
            @bpg = stats_hash[0]["total"]["bpg"]
            @spg = stats_hash[0]["total"]["spg"]
            @fgp = stats_hash[0]["total"]["fgp"]
            @tpp = stats_hash[0]["total"]["tpp"]
            @ftp = stats_hash[0]["total"]["ftp"]
        end
    end
        
    def self.all
        @@all
    end

end