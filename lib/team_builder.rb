module TeamBuilder
  # def summoner_summary_page

  # end

  def find_summoner_opponents
    result=nil
    lolking = "http://www.lolking.net"
    opponents = []
    if !name.blank? then
      encoded_summoner_name = CGI::escape(name) #if !name.blank?
      puts "ENCODED_SUMMONER_NAME ******************: #{encoded_summoner_name}"
      summoner_summary_page = lolking + "/search?name=#{encoded_summoner_name}"
      puts "BEFORE NOKOGIRI"
      summoner_summary_page_html = Nokogiri::HTML(open(summoner_summary_page)) if summoner_summary_page #added this v1
      if summoner_summary_page_html.blank?
        return nil
      end
      puts "AFTER NOKOGIRI"
      summoner_summary_page_html.xpath("//div[@class='search_result_item']").each do |resultItem|
        puts "AFTER SUMMONER_SUMMARY_PAGE_HTML"
        #No need to click on matches tab
        onclick = resultItem['onclick']
          if onclick.include? 'summoner/na'
            index = onclick.index("'") + 1
            link = onclick[index..onclick.length-1]
            index = link.index("'")-1
            summoner_profile = lolking + link[0..index]
            puts "BEFORE SECOND NOKOGIRI"
            summoner_profile_html = Nokogiri::HTML(open(summoner_profile))
            puts "BEFORE DO LOOP"
            summoner_profile_html.search('div.match_win','div.match_loss').each do |win_loss_div|
              puts "BEFORE WIN_LOSS_DIV"
              if win_loss_div.at_css('div.match_details_extended table tr td:nth-child(3) table tr:nth-child(2) td:nth-child(2)') != nil then
                puts "before for loop"
                for i in 2..4 #for now, just do 3, but later do error checking.
                  puts "IN FOR LOOP:  #{i}."
                  #binding.pry
                  name_div = win_loss_div.at_css("div.match_details_extended table tr td:nth-child(3) table tr:nth-child(#{i}) td:nth-child(2)")
                  #binding.pry
                  opponents<<name_div.content if name_div
                  puts "OTHER NAMES ****: #{name_div.content}" if name_div
                end
              end
              #binding.pry
          end
        end
        result = opponents.uniq #<<<why ned 'return' here?
        puts "after result in loop" #why can't use o_name here?
      end
      result
      puts "after result out of loop"
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

def remove_dupes
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

