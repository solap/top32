class Post < ActiveRecord::Base
  attr_accessible :name, :team_elo, :team_name

def create_team_list(posts=[])
    #binding.pry
    lolking = "http://www.lolking.net"
    @posts = Post.all
    @posts = @posts.sort_by!{|e| e.team_elo}.reverse
    #@posts = @posts.order("team_name desc")

    @posts.each do |post|
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
          #puts "Nokogiri::HTML(open(summoner_profile))"
          team_name = summoner_profile_html.at_css("ul.personal_ratings li:last div:nth-child(2)").text
          #puts "finished team name"
          #puts "team_name ********* " + team_name


          if team_name != ""

            points = summoner_profile_html.at_css("ul.personal_ratings li:last div:nth-child(7) span").text

            #puts "finished team_elo"
            detail = summoner_profile_html.at_css("title").text
          end
          #puts "title: " + detail.inspect.to_i
          #puts "team elo: " + points.to_i
          #puts "before post.name"
          post.name = post.name
          #puts "post.name"
          post.team_name = team_name.inspect
          #puts "post.team_name"
          post.team_elo = points.to_i
          #puts "post.team_elo"
          puts post.name + " " + post.team_name + " " + post.team_elo.to_s
          post.save
          #puts "post.save"
        end

      end
      #puts "out summoner_summary_page_html.xpath"
    end
    #binding.pry
    #@posts = @posts.order("team_elo desc")
    render "index"
  end
end


