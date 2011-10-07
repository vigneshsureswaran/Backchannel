class UsersController < ApplicationController

  layout "loginpage"
  # GET /users
  # GET /users.json
  def index
    if(session[:user_id]!=nil)
      redirect_to "/posts"
    else
    @users = User.all

    respond_to do |format|
      format.html # index1.html.erb
      format.json { render json: @users }
    end
      end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
     format.html # show.html.erb
     format.json { render json: @user }
    end

  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

     if User.find(:all).empty?
       @user.role="Admin"
     else
       @user.role="User"
     end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }

      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @userQuestions = @user.posts
    @userQuestions.each do |qns|
      if( qns.id == qns.post_id )
        Post.find(:all,:conditions => ["post_id = ?",qns.id] ).each &:destroy
      end
    end
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_showallusers_path }
      format.json { head :ok }
    end
  end

  def authenticate

     @user = User.new(params[:userform])
     #find records with username,password
     valid_user = User.find(:first,:conditions => ["username = ? and password = ?",@user.username, @user.password])

    #if statement checks whether valid_user exists or not
    if valid_user
      #creates a session with username
      session[:id]=nil
      session[:user_id]=nil
      session[:admin]=nil
      session[:name]=nil

      session[:id]=valid_user.username
      session[:user_id]=valid_user.id
      session[:admin]=valid_user.role
      session[:name]=valid_user.fullname

      redirect_to "/posts"


    else
      respond_to do |format|
      format.html { redirect_to @user, notice: 'Invalid Username/Password.' }
      end

    end
  end

  def logout
    reset_session
    redirect_to "/users"
  end

  def login
    redirect_to users_authenticate_path
  end

  def showallusers
    if(session[:user_id]==nil || session[:admin]!="Admin")
      redirect_to "/users", notice: "Not an admin.. Out of limits for you.."
    else
      @users = User.all

    respond_to do |format|
      format.html # index1.html.erb
      format.json { render json: @users }
    end
    end


  end

  def reports

  end
end
