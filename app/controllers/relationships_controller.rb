class RelationshipsController < ApplicationController
    before_action :logged_in_user
    
    def create
        @user = User.find(params[:followed_id])
        current_user.follow(@user)
        # format.html または format.js のいずれか一方が実行される
        respond_to do |format|
            format.html { redirect_to @user }
            # app/views/relationships/create.js.erb
            format.js
        end
    end
    
    def destroy
        @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |format|
            format.html { redirect_to @user }
            # app/views/relationships/destroy.js.erb
            format.js
        end
    end
    
end
