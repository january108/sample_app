class Relationship < ApplicationRecord
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
    validates :follower_id, presence: true
    validates :followed_id, presence: true
    validate  :cant_follow_myself
    
    private
    
        # 自身をフォローできない
        def cant_follow_myself
            if follower_id == followed_id
                errors.add(:followed_id, "should not follow myself")
            end
        end
        
end
