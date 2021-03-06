class UsersController < ApplicationController
    skip_before_action :authorized, only: [:new, :create]
    before_action :find_user, only: [:show, :delete]


    def index
        @users = User.all
    end 

    def show
        @user = find_user
        # @user_routines = Routine.select{|r| r.user_id == @user.id}
        @user_routines = []
        Routine.where(user_id: current_user.id).map{|r| r.name}.uniq.each do |r|
            @user_routines << Routine.find_by(name: r)
        end
        flash[:notice] = ""
    end

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.create(user_params)
        if @user.valid?
            flash[:notice] = "Signup successful! Welcome, #{@user.name}"
            session[:user_id] = @user.id
            redirect_to user_path(@user)
        else
            render :new
        end
    end


    def edit
        render :edit
    end

    def update
        # @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "Successfully updated profile"
            redirect_to @user
        else
            render :edit
        end
    end


    def delete
        # @user = User.find(params[:id])
        #byebug
        @user.destroy
        flash[:notice] = "Account deleted"
        redirect_to users_path
    end


    # private methods
    private

    def find_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :password, :name, :age, :height_inch, :weight, :weigt_goal, :sex)
    end
end