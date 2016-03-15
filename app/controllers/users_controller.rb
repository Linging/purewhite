class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update,:show,:destroy]
  before_action :correct_user, only: [:edit, :update]
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
       @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
  	@users = User.paginate(page: params[:page])
  end

  def edit
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
              @user.send_activation_email
  		redirect_to root_url
  		flash[:info] = "Please check your Emailbox for activation"
  	else
  		render 'new'
  	end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile uodate!"
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "User deleted"
  	redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  		                            :password_confirmation)    #strong params : sure that only nesserary params can be pass_in
  	end

  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_url) unless current_user?(@user)		
  	end
end
