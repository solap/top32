

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
    @posts = Post.all
    @posts.each do |post|
      urlEncodedString = CGI::escape(post.name)
      baseUrl = "http://www.lolking.net"
      url = baseUrl + "/search?name=#{urlEncodedString}"
      doc = Nokogiri::HTML(open(url))
      doc.xpath("//div[@class='search_result_item']").each do |resultItem|
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
          #puts detail.inspect
          #puts points.to_i
          post.name = post.name
          post.team_name = diversity.inspect
          post.team_elo = points.to_i
          puts post.team_name + " " + post.team_elo.to_s
          post.save
        end
      end
    end
    @posts = @posts.order(team_elo).reverse
    render "index"
  end
end
