

class Summoner
	attr_accessor :summoner_name, :team_name, :team_elo
	def initialize(summoner_name, team_name, team_elo)
        @summoner_name = summoner_name
		@team_name = team_name
		@team_elo = team_elo
	end
	#pull in the "replace space" thing into summoner_name somehow
end

#1stPerson = Summoner("tamtar", var_team, var_elo)



#messed around with the ends.