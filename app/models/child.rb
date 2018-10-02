class Child < ApplicationRecord
  has_many :hosting_session_spot_children
  has_many :hosting_session_spots, :through => :hosting_session_spot_children
  has_many :child_notes
  
  def full_name
    "#{last_name}, #{first_name}"
  end
  
  def public_name
    return identifier unless first_name
    "#{identifier} \"#{first_name[0]}\""
  end
  
  def age
    return nil if birthday.nil?
    ((Time.zone.now - birthday.to_time) / 1.year.seconds).floor    
  end
  
end
