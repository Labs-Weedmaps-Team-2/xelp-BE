class User < ApplicationRecord
  has_many :comment_id
    def self.create_with_omniauth(auth)
      user = create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.username = auth["info"]["nickname"]
        user.photo = auth["info"]['image']
        user.email = auth["info"]['email']
      end
    end
end
