class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created !"
      redirect_to root_url
    else
      @feed_items = current_user.microposts.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # ブラウザによっては、refferer が実装されていない場合があり、その場合は root_url に戻す
    # redirect_to request.referrer || root_url
    redirect_back(fallback_location: root_url)
  end
  
  private
  
    def micropost_params
      # マスアサインメントを避けるために
      # Strong parameter を使用する
      params.require(:micropost).permit(:content, :picture)
    end
    
    # 当メソッドが呼ばれるのは、 DELETE /microposts/:id 
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
