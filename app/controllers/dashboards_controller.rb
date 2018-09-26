class DashboardsController < ApplicationController

  def index
  end
  
  def lorem
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
  end
  
  def statuses
    [
      {:text => 'Available', :color => '#1E9A1E'},
      {:text => 'On-Hold', :color => 'orange'}
    ]
  end
  
  def children
    @kids = []
    
    1.upto(49) {|i|
      length = 96 + rand(64)
      @kids << {name: "U1234-#{i}", img: "kids/#{1000+i}_tn.jpg", description: lorem.truncate(length, separator: /\s/)}
    }
    
    @kids.shuffle!

  end

  def children2
    @kids = []
    
    1.upto(49) {|i|
      length = 96 + rand(64)
      @kids << {name: "U1234-#{i}", img: "kids/#{1000+i}_tn.jpg", description: lorem.truncate(length, separator: /\s/), :status => statuses.sample, :scholarship => rand(6) == 1 ? 'Scholarship' : nil }
    }
    
    @kids.shuffle!
    
  end
  
  def child
    @kid = {
      :name => "U9999",
      :description => lorem,
      :status => ['On-Hold','Available'].sample,
      :country => ['Latvia','Ukraine'].sample,
      :scholarship => rand(3)*100,
      :size => ['Single', 'Sibling Pair', 'Sibling Group'].sample,
    }
    @images = []

    1.upto(49) {|i|
      @images << {:thumbnail => "kids/#{1000+i}_s.jpg", :medium => "kids/#{1000+i}_md.jpg", :full_size => "kids/#{1000+i}.jpg", :caption => "This is a caption about image #{1000+i}.jpg"}
    }
    
    @images = @images.sample(5);


  end
  
  def register
    render :layout => "empty"
  end
  
end
