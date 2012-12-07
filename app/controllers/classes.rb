
doc.xpath("//div[@class='search_result_item']").each do |resultItem|
  	baseUrl = "http://www.lolking.net"
	urlEncodedString = CGI::escape(post.name)
	url = baseUrl + "/search?name=#{urlEncodedString}"
	#url = baseUrl + "/search?name=#{post.name}"
	doc = Nokogiri::HTML(open(url))
	onclick = resultItem['onclick']
	if onclick.include? 'summoner/na'
		index = onclick.index("'") + 1
		link = onclick[index..onclick.length-1]
		index = link.index("'")-1
		goToUrl = baseUrl + link[0..index]
		doc2 = Nokogiri::HTML(open(goToUrl))
		detail = doc2.at_css("title").text
		diversity = doc2.at_css("ul.personal_ratings li:last div:nth-child(2)").text
		points = doc2.at_css("ul.personal_ratings li:last div:nth-child(7) span").text
		puts detail.inspect

		puts points.inspect.to_i

		post.name = post.name
		post.team_name = diversity.inspect
		#post.team_elo = points.inspect.to_i  # < < < <IS THIS WORKING RIGHT?
		post.team_elo = points.to_i
		puts post.team_elo
		post.save

	end
end
#messed around with the ends.