class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログインが成功したら Cookie に記憶し、ユーザ情報のページへ
      log_in user
      remember user
      redirect_to user
    else
      # ログイン失敗のエラーメッセージを表示
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end

end
