class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
  	
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
              log_in @user       #login after signup successed
  		redirect_to @user
  		flash[:success] = "Welcome to Sample App"
  	else
  		render 'new'
  	end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  									 :password_confirmation)    #strong params : sure that only nesserary params can be pass_in
  	end
end
