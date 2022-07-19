class Scraper

    def self.get_teams
        url = URI.parse("https://data.nba.net/data/10s/prod/v1/2022/teams.json")
        response = Net::HTTP.get_response(url)
        hash = JSON.parse(response.body)
        teams = hash["league"]["standard"]
        teams
    end

    def self.get_players
        url = URI.parse("https://data.nba.net/10s/prod/v1/2022/players.json")
        response = Net::HTTP.get_response(url)
        hash = JSON.parse(response.body)
        players = hash["league"]["standard"]
        players
    end

    def self.get_player_stats(player_id)
        url = URI.parse("https://data.nba.net/data/10s/prod/v1/2022/players/#{player_id}_profile.json")
        response = Net::HTTP.get_response(url)
        hash = JSON.parse(response.body)
        stats = hash["league"]["standard"]["stats"]["regularSeason"]["season"]
    end
 
end