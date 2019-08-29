class User < ApplicationRecord
    def self.create_with_omniauth(auth)
      user = create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.username = self.assign_username(auth)
        user.photo = auth["info"]['image']
        user.email = auth["info"]['email']
      end
    end
    private

    def self.assign_username(auth)
      puts auth
      if (auth.provider == 'github')
        return auth["info"]["nickname"]
      else
        return auth["info"]["email"].split('@')[0]
      end
    end
end
