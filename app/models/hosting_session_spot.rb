class HostingSessionSpot < ApplicationRecord
  belongs_to :hosting_session
  has_many :hosting_session_spot_children
  has_many :children, :through => :hosting_session_spot_children
  belongs_to :family, optional: true
  belongs_to :status, :class_name => 'SpotStatus'
  
  scope :on_hold, -> { where(status: SpotStatus.find_by_name('On-Hold'))}
  scope :hosted, -> { where(status: SpotStatus.find_by_name('Hosted'))}
  scope :available, -> { where(status: SpotStatus.find_by_name('Available'))}
  
  
  def public_name
    children.map{|child| child.public_name}.join ', '
  end
  
  def country
    children.first.country
  end
  
end
