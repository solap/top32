require "team_builder"
class Post < ActiveRecord::Base
	attr_accessible :name, :team_elo, :team_name
	include TeamBuilder
  	def self.create_team_list
=begin
	    Post.all.each do |post|
	    	new_summoners = post.find_summoner_opponents
	    	new_summoners.each do |opponent_name|
	    		if Post.find_by_name(opponent_name)
	    			Post.create(:name => opponent_name)
	    		end
	    	end
	      #encode the string to deal with spaces
	    end
=end
	    Post.all.each do |post|
	    	details = post.get_team_details
	    	post.update_attributes(details)

	    end
	    #binding.pry
	end


end


