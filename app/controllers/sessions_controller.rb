class SessionsController < ApplicationController
    skip_before_action :authorized, except: :destroy
  
    def new
      if logged_in?
        redirect_to user_path(current_user) 
      else
        render :new
      end
    end
  
    def create
      # params {username: 'me', password: '1234'}
      # find user by the username found in params from the login form
      @user = User.find_by({ username: params[:username] })
  
      # attempt to authenticate the user by username
      if !!@user && @user.authenticate(params[:password])
        flash[:notice] = "Successfully logged in #{@user.username}!"
        # store the logged in user somewhere
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        flash[:notice] = "Invalid username or password"
        redirect_to login_path
      end
    end
  
    def destroy
      session.delete(:user_id)
      flash[:notice] = "Successfully logged out!"
      redirect_to login_path
    end
  end