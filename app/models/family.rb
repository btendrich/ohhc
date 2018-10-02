class Family < ApplicationRecord
  
  def short_name
    "#{last_name} (#{state})"
  end
end
