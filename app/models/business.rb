class Business < ApplicationRecord
  has_many :comments

  has_many_attached :photos
end
