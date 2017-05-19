class User < ApplicationRecord
    attr_accessor :remember_token
    
    before_save {self.email = email.downcase}
    
    validates :name, presence: true, length: { maximum: 50 }
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, 
            format:{ with: VALID_EMAIL_REGEX }, 
            uniqueness:{case_sensitive:false}
            
    validates :password, presence: true, length: { minimum: 6 }
    
    has_secure_password
    
    # クラスメソッド
    class << self
        # 渡された文字列のハッシュ値を返す
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end
        
        # ランダムなトークンを返す
        def new_token
            SecureRandom.urlsafe_base64
        end
    end
    
    # 永続セッションのためにユーザを永続化する
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # 渡されたトークンがダイジェストと一致したら true を返す
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        # valid hash => h =~ /^\$[0-9a-z]{2}\$[0-9]{2}\$[A-Za-z0-9\.\/]{53}$/
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    # ユーザのログアウト情報を破棄する
    def forget
        update_attribute(:remember_digest, nil)
    end
end
