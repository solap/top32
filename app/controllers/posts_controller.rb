

class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
#   @ak = do_web_thing(post)
    #Code block goes back here.

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def do_web_thing
    lolking = "http://www.lolking.net"
    @posts = Post.all
    #@posts = @posts.order("team_name desc")

    #@posts = @posts.sort_by!{|post| post.team_elo}.reverse
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

    @posts = @posts.order("team_elo desc")
    render "index"
  end
  def yadda

  end
end
