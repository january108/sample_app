# -*- coding: utf-8 -*-
#
# == Userモデルに関するヘルパー
#
# Author:: january108
# Version:: 0.0.1
#
module UsersHelper
    
    # @param user [User] gravatar画像を表示するユーザ
    # @param size [int] gravatar画像のサイズ。デフォルト80。
    # @return [tag] gravatar画像のイメージタグ
    def gravatar_for(user, size:80)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        #size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt:user.name, class:"gravatar")
    end
    
    protected
        def hoge_protected
        end
        
    private
        def hoge_private
        end
    
end
