class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.find(:all, :conditions => ['id=post_id'])
    @posts.each do |post|
      @no_votes = post.votes.count
    @creation = post.id  - Post.minimum(:id)
      post.weight = @no_votes + @creation
      post.weight = post.weight * -1
      post.save

    end
    @posts =  Post.find(:all, :conditions => ['id=post_id'])
    @posts = @posts.sort_by(&:weight)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  #search by username
  def searchByUser
    puts "enters here too"
   @user = User.new(params[:search_user])
    puts "jii"
   puts @user.username
    @username = @user.username
    @username = @username.strip
    @user = User.find_by_username(@username)
    puts "jii"
    @allposts = []
    if(@user!=nil)
   @allposts = Post.find_all_by_user_id(@user.id)
    end
     @posts1 = []
    @posts = []

   puts "posts displayed"
      #Collected all the main threads with this userId
     @allposts.each do |post|
       @parentPost = Post.find_by_id(post.post_id)
       unless @posts.include?(@parentPost)
       @posts << @parentPost
       end

     end
    @posts = @posts.sort_by(&:weight)
        @posts1 << @posts
        @posts1 << @username

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts1 }
    end

   puts "type"
   puts @posts.class

  end

  #display results function for searchByUser

   def showrepliesUser
     @uname = params[:username]
     @userid = User.find_by_username(@uname)
    @posts = Post.find_all_by_post_id(params[:id],:conditions => ["user_id = ?",@userid.id])
   end

  # Search by keyword

  #search by username
  def searchByText
    puts "enters here too"

    # Here im just creating a user with username = the search string.. copied from searchByUser.. so.. trying to chang
    # as less as possible
   @user = User.new(params[:search_user])
    puts "jii"
   puts @user.username
    @username = @user.username
    @username = @username.strip
    @username = "%"+@username+"%"
    puts "jii"
    @allposts = []
    if(@user!=nil)
   @allposts = Post.find(:all, :conditions => ["post like ?",@username])
    end
     @posts1 = []
    @posts = []

   puts "posts displayed"
      #Collected all the main threads with this userId
     @allposts.each do |post|
       @parentPost = Post.find_by_id(post.post_id)
       unless @posts.include?(@parentPost)
       @posts << @parentPost
       end

     end
        @posts = @posts.sort_by(&:weight)
        @posts1 << @posts
        @posts1 << @username

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts1 }
    end

   puts "type"
   puts @posts.class

  end

   def showrepliesText
     @uname = params[:username]
     @id = params[:id]
     @posts = Post.find(:all,:conditions => ["post like ? and post_id = ?",@uname,@id])
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
    if(session[:user_id]==nil)
     redirect_to "/users", notice: 'Please login to post'
    else
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
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
    @post.user_id=session[:user_id]
    if @post.post.blank?
       #redirect_to posts_path
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'Post is empty' }
      end
    else
       respond_to do |format|
      if @post.save
        parent_postid = @post.id
        @post.post_id=parent_postid
        @post.update_attribute("post_id", parent_postid)

        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
#        redirect_to posts_path
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
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
        format.json { head :ok }
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
    @postid = @post.id
    puts @post.id
    @post.destroy
    @subpost = Post.find_all_by_post_id(@postid)

    puts @subpost
    @subpost.each do |post|
      puts post
      post.destroy
    end

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  def createreply
    if(session[:user_id]==nil)
     redirect_to "/users", notice: 'Please login to reply'
    else
      @post = Post.find(params[:id])
    end


    #@post = Post.find(params[:id])
  end

  def reply
    if(session[:user_id]==nil)
      redirect_to "/posts", notice: "Please login in oder to reply"
    else
    @post = Post.new
    @post.post_id = params[:parent_post_id]
    @post.post =  params[:post]
    @post.user_id = session[:user_id]

    respond_to do |format|
    if @post.save()
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
    end
    end
      end
  end

  def countvotes

    if(session[:user_id]==nil)
     redirect_to "/users", notice: 'Please login to vote'
    else
    @vote = Vote.new

    @vote2 = Vote.find(:all, :conditions => ["user_id = ? and post_id = ?", session[:user_id], params[:id] ])
    @post2 = Post.find(:all, :conditions => ["user_id = ? and id = ?", params[:user_id], params[:id]])
    p @vote2
    p @vote2.length
    p @post2.length

    if (session[:user_id].to_s() == params[:user_id].to_s()|| session[:user_id]==nil)
      respond_to do |format|
           format.html {redirect_to posts_path, notice: 'Sorry, You cannot vote for this post'}
      end


    else
      if @vote2.length == 0
        puts "success"
        @vote.post_id = params[:id]
        @vote.user_id = session[:user_id]
        @vote.save
        redirect_to posts_path

      else
        puts "already voted"
        redirect_to posts_path

      end

    end
   end

  end

  def report
    @posts = Post.all
    @posts = Post.find(:all, :order=> "post_id")
  end

  def showreplies
    @posts = Post.find_all_by_post_id(params[:id])
  end
end
