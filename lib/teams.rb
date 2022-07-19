class Teams

    attr_reader :team_id, :name, :tricode, :roster

    @@all = []

    def initialize(team_hash)
        @team_id = team_hash["teamId"]
        @name = team_hash["fullName"]
        @tricode = team_hash["tricode"]
        @@all << self
        @roster = []
    end

    def self.create_from_api
        teams = Scraper.get_teams
        teams.each {|team| Teams.new(team)}
    end

    def self.all
        @@all
    end
 
end