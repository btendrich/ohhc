class DashboardsController < ApplicationController

  def dashboard_4
    render :layout => "layout_2"
  end
  
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
    @kid = Struct.new( :name, :description, :status, :country )
    @images = [
      {:full_size => 'kids/1001.jpg', :thumbnail => 'kids/1001_tn.jpg', :caption => 'This is a caption'},
      {:full_size => 'kids/1002.jpg', :thumbnail => 'kids/1002_tn.jpg', :caption => 'This is a caption'},
      {:full_size => 'kids/1003.jpg', :thumbnail => 'kids/1003_tn.jpg', :caption => 'This is a caption'},
      {:full_size => 'kids/1004.jpg', :thumbnail => 'kids/1004_tn.jpg', :caption => 'This is a caption'},
      {:full_size => 'kids/1005.jpg', :thumbnail => 'kids/1005_tn.jpg', :caption => 'This is a caption'},
    ]
  end
  
end
