class Business < ApplicationRecord
  has_many_attached :photos
  has_many :reviews
  scope :geo, -> (minLat, maxLat, minLng, maxLng) {  where("latitude >= :minLat AND latitude <= :maxLat AND longitude >= :minLng AND longitude <= :maxLng", {minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng} )}

end
