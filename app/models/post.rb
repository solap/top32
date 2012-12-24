require "team_builder"
#require "is_eligible"

class Post < ActiveRecord::Base
	attr_accessible :name, :team_elo, :team_name
	include TeamBuilder
	validates :name, presence: true, uniqueness: true
	# fix the error that comes when i try to create

	def self.create_team_list
    Post.all.each do |post|
    	if !post.name.blank?  then
	    	details = post.get_team_details
        #binding.pry
	    	post.update_attributes(details) if details != "none"
    	end
    end
	end

	def self.add_players
    last_id=Post.all.last.id
    current_players=Post.where("id<=#{last_id}")
    current_players.all.each do |post|
    	if !name.blank?
	    	new_summoners = post.find_summoner_opponents
    	end
      #binding.pry
      if !new_summoners.blank? then
	    	new_summoners.each do |opponent_name|
          result=add_player(opponent_name)
	    	end
      end
    end
	end

  def self.purge_low_elo_players
    min_elo = 1500
    puts "Total rows: #{Post.count}"
    nuke_rows = Post.where("team_elo<#{min_elo}")
    puts "Nuking all players with lower than #{min_elo} team elo."
    puts "NUMBER OF LOW ELO ROWS: #{nuke_rows.count.to_s}"
    nuke_rows.destroy_all
    puts "Done with purging low elo players."
    puts "Total rows: #{Post.count}"
  end

  def self.purge_no_team_players
    puts "Total rows: #{Post.count}"
    nuke_rows = Post.where("team_elo is NULL")
    puts "NUMBER OF ROWS WITH NO TEAMS: #{nuke_rows.count.to_s}"
    nuke_rows.destroy_all
    puts "Done with purging players with no team."
    puts "Total rows: #{Post.count}"
  end

end