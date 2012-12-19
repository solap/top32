require "team_builder"

class Post < ActiveRecord::Base
	attr_accessible :name, :team_elo, :team_name
	include TeamBuilder
	validates :name, presence: true, uniqueness: true
	# fix the error that comes when i try to create

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
		    	puts "out of find_summoner_opponents"
	    	end
	    	if !new_summoners.blank? then
		    	new_summoners.each do |opponent_name|
		    		puts "before post"
		    		if !Post.exists?(name: opponent_name)
		    			result=Post.create(name: opponent_name)
		    		puts "after post"
		    		end
		    	end
	    	end
	    end
	end
end