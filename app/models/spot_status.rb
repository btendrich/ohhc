class SpotStatus < ApplicationRecord
  
  def color
    return 'green' if name =~ /available/i
    return 'yellow' if name =~ /hold/i
    return 'red' if name =~ /hosted/i
    return 'red' if name =~ /rehost/i
  end

end
