module TeamBuilder
  # def summoner_summary_page

  # end

  def find_summoner_opponents
    result=nil
    lolking = "http://www.lolking.net"
    opponents = []
    if !name.blank? and !player_exist?(name) then
      encoded_summoner_name = CGI::escape(name) #if !name.blank?
      puts "ENCODED_SUMMONER_NAME ******************: #{encoded_summoner_name}"
      summoner_summary_page = lolking + "/search?name=#{encoded_summoner_name}"
      summoner_summary_page_html = Nokogiri::HTML(open(summoner_summary_page)) if summoner_summary_page #added this v1
      if summoner_summary_page_html.blank?
        return nil
      end
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
                for i in 2..6 #for now, just do 3, but later do error checking.
                  #binding.pry
                  name_div = win_loss_div.at_css("div.match_details_extended table tr td:nth-child(3) table tr:nth-child(#{i}) td:nth-child(2)")
                  #binding.pry
                  opponents<<name_div.content if name_div
                  #puts "OTHER NAMES ****: #{name_div.content}" if name_div
                end
              end
              #binding.pry
          end
        end
        result = opponents.uniq #<<<why need 'return' here?
      end
      result
    end
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
          #detail = summoner_profile_html.at_css("title").text
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

def player_exist?(opponent_name)
  return nil if opponent_name.empty?
  if !Post.exists?(name: opponent_name)
    true
  else
    false
  end
end

def add_player(opponent_name)
  if !Post.exists?(name: opponent_name)
    result=Post.create(name: opponent_name)
    puts opponent_name + " posted."
    true
  else
    #puts opponent_name + " NOT posted because it exists already."
    false
  end
end

def purge_players
  min_elo = 1600
  puts "Nuking all players with lower than #{min_elo} team elo."
  puts "Total rows: #{Post.count}"
  nuke_rows = Post.where("team_elo<#{min_elo}")
  puts "NUMBER OF LOW ELO ROWS: #{nuke_rows.count.to_s}"
  nuke_rows.destroy_all
  low_elo_rows = Post.where("team_elo is NULL")
  puts "NUMBER OF NIL ROWS: #{low_elo_rows.count.to_s}"
  low_elo_rows.destroy_all
  puts "Done with purging."
end

if __FILE__ == $0 then
  require "cgi"
  require "nokogiri"
  class FakeName
    def initialize(name="tamtar")
      @name = name
    end
    include TeamBuilder
    def name
      @name
    end
  end
  FakeName.new(ARGV.first).find_summoner_opponents
end

