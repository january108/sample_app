class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger
  end
  
  def new
    @user = User.new
    # debugger
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App (^^)/"
      redirect_to @user
      #debugger
    else
      render 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if(@user.update_attributes(user_params))
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "User [  #{user.name}  ] deleted"
    # FIXME 削除時に開いていたページに遷移させたい
    redirect_to users_url
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # 正しいユーザかどうか確認する
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  
    # 管理者かどうか調べる
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
