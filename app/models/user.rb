class User < ApplicationRecord
    #
    # relation
    #

    # micropost
    has_many :microposts, dependent: :destroy
    
    # following / followed user 
    has_many :active_relationships, 
               class_name: "Relationship",
               foreign_key: "follower_id",
               dependent:   :destroy
    has_many :passive_relationships, 
               class_name: "Relationship",
               foreign_key: "followed_id",
               dependent:   :destroy
    # フォローしているユーザの集合を簡単に取得するためのショートカット
    # このショートカットは active_relationships.map(&:followed) と同じ結果となるが、
    # mapナントカという書き方は、メソッドチェーンをたどる過程でそれぞれクエリが吐かれ、性能が悪い
    # (1) このUser の (2) relationshipを取得し、(3) さらにuserを取得する
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    

    attr_accessor :remember_token
    
    #
    # validation
    #
    before_save {self.email = email.downcase}
    validates :name, presence: true, length: { maximum: 50 }
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, 
            format:{ with: VALID_EMAIL_REGEX }, 
            uniqueness:{case_sensitive:false}
            
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
    has_secure_password
    
    
    #
    # method 
    #

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
    
    # ユーザのfeed
    # あとで他の人のフィードも混ぜたいという目論見あり
    def feed
        # SQL injection対応してくれる
        Micropost.where("user_id = ?", self.id)
    end
    
    # ユーザをフォローする
    def follow(other_user)
        active_relationships.create(followed_id: other_user.id)
        # p "follow #{self.name} => #{other_user.name}"
    end
    
    # ユーザをフォロー解除する
    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end
    
    # 現在のユーザがフォローしていたら true を返す
    def following?(other_user)
        following.include?(other_user)
    end
    
    # 現在のユーザがフォローされていたら true を返す
    def followed?(user)
        followers.include?(user)
    end
    
end
