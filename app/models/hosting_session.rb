class HostingSession < ApplicationRecord
  has_many :session_spots
  has_many :children, :through => :session_spots
end
