class Business < ApplicationRecord
  has_many_attached :photos
  has_one_attached :image_url
  has_many :reviews, dependent: :destroy
  scope :geo, -> (minLat, maxLat, minLng, maxLng, term) {  where("latitude >= :minLat AND latitude <= :maxLat AND longitude >= :minLng AND longitude <= :maxLng AND (lower(name) LIKE :term OR lower(category) LIKE :term ) ", {minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng, term: "%#{term.downcase}%"} )}

end
