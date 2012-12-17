require "team_builder"

class Post < ActiveRecord::Base
	attr_accessible :name, :team_elo, :team_name
	include TeamBuilder
	validates :name, presence: true

  	def self.create_team_list
	    Post.all.each do |post|
	    	if !post.name.blank?  then
		    	details = post.get_team_details
		    	post.update_attributes(details)
		    	#binding.pry
	    	end
	    end
	    #binding.pry
	end

	def self.add_players
	    Post.all.each do |post|
	    	if !name.blank?
		    	new_summoners = post.find_summoner_opponents
	    	end
	    	if !new_summoners.blank? then
		    	new_summoners.each do |opponent_name|
		    		if !Post.exists?(name: opponent_name)
		    			result=Post.create(name: opponent_name)
		    		end
		    	end
	    	end
	    end
	end
end