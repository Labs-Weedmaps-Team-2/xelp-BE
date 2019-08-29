class User < ApplicationRecord
  mount_uploader :photo, PhotoUploader
end
