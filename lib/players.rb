class Players

    attr_reader :first_name, :last_name, :player_id, :team_id, :team, :dob, :age, :number, :position, :weight, :height, :ppg, :rpg, :apg, :topg, :bpg, :spg, :fgp, :tpp, :ftp 

    @@all = []

    def initialize(player_hash)
        @first_name = player_hash["firstName"]
        @last_name = player_hash["lastName"]
        @player_id = player_hash["personId"]
        @team_id = player_hash["teamId"]
        @dob = player_hash["dateOfBirthUTC"]
        @number = player_hash["jersey"]
        @position = player_hash["pos"]
        @height = "#{player_hash["heightFeet"]}\'#{player_hash["heightInches"]}\" - #{player_hash["heightMeters"]}m" 
        @weight = "#{player_hash["weightPounds"]}lbs - #{player_hash["weightKilograms"]}kg"
        self.get_team
        self.get_age if @dob != ""
        @@all << self
    end

    def self.create_from_api
        players = Scraper.get_players
        players.each {|player| Players.new(player)}
    end

    def get_stats
        stats = Scraper.get_player_stats(@player_id)
        if !stats.empty?
            @ppg = stats["ppg"]
            @rpg = stats["rpg"]
            @apg = stats["apg"]
            @topg = stats["topg"]
            @bpg = stats["bpg"]
            @spg = stats["spg"]
            @fgp = stats["fgp"]
            @tpp = stats["tpp"]
        end
    end

    def self.all
        @@all
    end

    def get_team
        Teams.all.each do |team| 
            @team = team if team.team_id == @team_id
            team.roster << self if team.team_id == @team_id
        end
    end

    def get_age
        birthday = @dob.split("-").collect {|num| num.to_i}
        if birthday[1] >= Time.now.month && birthday[2] >= Time.now.day
            @age = Time.now.year-birthday[0]-1
        else
            @age = Time.now.year-birthday[0]
        end
    end

end