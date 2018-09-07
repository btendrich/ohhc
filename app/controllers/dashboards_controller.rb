class DashboardsController < ApplicationController

  def dashboard_4
    render :layout => "layout_2"
  end
  
  def index
  end
  
  def children
    @lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
    
    @kids = []
    
    1.upto(10) {|i|
      @kids << {name: "U1234-#{i}", img: "kids/#{1000+i}_tn.jpg", description: @lorem}
    }
    
  end
  
  def child
  end
  
end
