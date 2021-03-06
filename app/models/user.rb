class User < ApplicationRecord
  has_one_attached :avatar
  has_many :reviews, dependent: :destroy
  
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
    if (auth.provider == 'github')
      return auth["info"]["nickname"]
    else
      return auth["info"]["email"].split('@')[0]
    end
  end
end
