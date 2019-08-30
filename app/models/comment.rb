class Comment < ApplicationRecord
  belongs_to :user_id
  belongs_to :business_id
end
