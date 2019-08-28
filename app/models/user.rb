class User < ApplicationRecord
    def self.create_with_omniauth(auth)
      puts auth["info"]['image']
      user = create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.username = auth["info"]["nickname"]
        user.photo = auth["info"]['image']
      end
      user.save
      user
    end
end
