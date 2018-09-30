class Child < ApplicationRecord
  has_many :session_spots
  has_many :hosting_sessions, :through => :session_spots
  has_many :child_photos
  
  def photos
    child_photos.order(:row_order)
  end
  
  def main_photo
    photos.first
  end

end
