class Post < ActiveRecord::Base
	attr_accessible :name, :team_elo, :team_name

	def self.create_team_list

	    lolking = "http://www.lolking.net"
	    Post.all.each do |post|
	      #encode the string to deal with spaces
	      encoded_summoner_name = CGI::escape(post.name)
	      summoner_summary_page = lolking + "/search?name=#{encoded_summoner_name}"
	      summoner_summary_page_html = Nokogiri::HTML(open(summoner_summary_page))
	      summoner_summary_page_html.xpath("//div[@class='search_result_item']").each do |resultItem|
	        #No need to click on matches tab
	        onclick = resultItem['onclick']
	        if onclick.include? 'summoner/na'
	          index = onclick.index("'") + 1
				link = onclick[index..onclick.length-1]
	          index = link.index("'")-1
	          summoner_profile = lolking + link[0..index]
	          summoner_profile_html = Nokogiri::HTML(open(summoner_profile))

	          #do Tadd's stuff here.
	          	#puts "bout to do some cool stuff here."
				summoner_profile_html.search('div.match_win','div.match_loss').each do |win_loss_div|
				#puts "BEGIN *******: "

				name = win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td:nth-child(2)').content
				puts win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td:nth-child(2)').content
				if !Post.exists?("name"=>name) then
				if !Post.exists?("name"=>name) then
					Post.create(:name=>name)
				end

=begin
				puts win_loss_div.at_css('div.match_details_extended table tr td:first-child table tr:nth-child(2) td').content.strip
				puts win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td').content.strip
=end
	          end
	        end
	      end
	    end
	    #binding.pry
	    #binding.pry
	    lolking = "http://www.lolking.net"
	    Post.all.each do |post|
	      #encode the string to deal with spaces
	      encoded_summoner_name = CGI::escape(post.name)
	      summoner_summary_page = lolking + "/search?name=#{encoded_summoner_name}"
	      summoner_summary_page_html = Nokogiri::HTML(open(summoner_summary_page))
	      summoner_summary_page_html.xpath("//div[@class='search_result_item']").each do |resultItem|
	        onclick = resultItem['onclick']
	        if onclick.include? 'summoner/na'
	          index = onclick.index("'") + 1
				link = onclick[index..onclick.length-1]
	          index = link.index("'")-1
	          summoner_profile = lolking + link[0..index]
	          summoner_profile_html = Nokogiri::HTML(open(summoner_profile))
	          team_name = summoner_profile_html.at_css("ul.personal_ratings li:last div:nth-child(2)").text
	          if team_name != ""
	            points = summoner_profile_html.at_css("ul.personal_ratings li:last div:nth-child(7) span").text
	            detail = summoner_profile_html.at_css("title").text
	          end
	          post.name = post.name
	          post.team_name = team_name.inspect
	          post.team_elo = points.to_i
	          puts post.name + " " + post.team_name + " " + post.team_elo.to_s
	          post.save
	        end
	      end
	      #puts "out summoner_summary_page_html.xpath"
	    end
	    #binding.pry
	end

end


