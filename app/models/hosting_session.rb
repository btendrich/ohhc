class HostingSession < ApplicationRecord
  has_many :hosting_session_spots
  has_many :children, :through => :hosting_session_spots
end
