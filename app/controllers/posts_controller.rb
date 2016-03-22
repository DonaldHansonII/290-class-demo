class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  # update takes form input and saves to db, edit opens the user page, new generates form for new post, create makes it into a post 
  # before action is called before the function in one of the controllers: authenticate_user is a method, afterwords it is saying the functions variables this should run with
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  # join does the opposite of split
  def edit
    tag_titles = @post.tags.map {|tag| tag.title }
    @post.tag_titles = tag_titles.join(',')
  end

  # POST /posts
  # POST /posts.json

  
  
  def create
    tags = get_tags(post_params[:tag_titles], ',')
    tags.each do |tag|
      @post.tags << tag
    end
    
    @post = current_user.posts.new(post_params)
    # create posts and add them to the current user collection (current_user)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
  
    return head(:forbidden) unless @post.user == current_user
    # guard clause, make sure the user who is trying to update is the user accessing the method
    
    tags = get_tags(post_params[:tag_titles], ',')
    @post.tags.clear
    tags.each do |tag|
      @post.tags << tag
    end
    
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    return head(:forbidden) unless @post.user == current_user
    
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def get_tags(str, delim)
      titles = str.split(delim)
      tags = []
      titles.each do |title|
        title.strip!
        next unless title && title.length # we don't want to add blank tags
        tags << Tag.where(title: title).first_or_create
      end
      return tags
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :string, :body, :username, :tag_titles)
    end
end
