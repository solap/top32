class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.all.uniq_by{|i| i.team_name}.sort_by{|e| e.team_elo}.reverse
    #@posts = Post.all.sort()
    @posts = Post.where("team_name <> ?", "").select("team_elo, team_name").group("team_name, team_elo").order("team_elo DESC")
    #@posts = Post.select("name, team_elo, team_name").order("team_elo DESC")
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
  def create_new_list
    Post.create_team_list
    redirect_to posts_path
  end
  def add_new_players
    Post.add_players
    redirect_to posts_path
  end
  def cleanup
    Post.purge_players
    redirect_to posts_path
  end
  def full
    Post.add_players
    Post.create_team_list
    Post.purge_players
    redirect_to posts_path
  end
end