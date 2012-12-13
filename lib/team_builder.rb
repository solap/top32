module TeamBuilder
	def find_summoner_opponents
		lolking = "http://www.lolking.net"
		opponents = []
		encoded_summoner_name = CGI::escape(name)
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
				summoner_profile_html.search('div.match_win','div.match_loss').each do |win_loss_div|
					if win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td:nth-child(2)') != nil then
						o_name = win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td:nth-child(2)').content
						puts win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td:nth-child(2)').content
					end
				opponents << o_name
				end
	        end
		end
		opponents.uniq
	end

	def get_team_details
		details = {}
	    lolking = "http://www.lolking.net"
		encoded_summoner_name = CGI::escape(name)
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
					puts points.to_s + team_name.inspect
					details[:name]=name
					details[:team_name]=team_name.inspect
					details[:team_elo]=points.to_i
				end

	        end
		end
		details
    end
end