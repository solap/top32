require "team_builder"
class Post < ActiveRecord::Base
	attr_accessible :name, :team_elo, :team_name
	include TeamBuilder
	validates :name, presence: true
  	def self.create_team_list

	    Post.all.each do |post|
	    	puts "NAME BEFORE FUNCTION CALL: #{name}"
	    	new_summoners = post.find_summoner_opponents if !name.blank?
	    	puts "new_summoners AFTER FUNCTION CALL: #{new_summoners.to_s}"
	    	if !new_summoners.blank? then
	    		puts "NEW_SUMMONERS BEFORE NEW_SUMMONERS.EACH: #{new_summoners.to_s}"
		    	new_summoners.each do |opponent_name|
		    		if !Post.exists?(name: opponent_name)
		    			Post.create(name: opponent_name)

		    		end
		    	end
	    	end
	      #encode the string to deal with spaces
	    end
	    if !new_summoners.blank?
	    	puts "IN NEW SUMMONERS.ANY: #{new_summoners.to_s}"
		    Post.all.each do |post|
		    	if !post.name.blank?  then
			    	puts "SUMMONER NAME: #{post.name}"
			    	details = post.get_team_details
			  		puts "DETAILS: #{details}"
			    	post.update_attributes(details)
			    	puts "POST: #{post.inspect.to_s}"
		    	end
		    end
		end
	    #binding.pry
	end


end


