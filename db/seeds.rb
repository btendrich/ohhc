# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

spot_statuses = [
  {:id => 1, :name => 'Available', :color => '#1E9A1E'},
  {:id => 2, :name => 'On-Hold', :color => 'orange'},
  {:id => 3, :name => 'Rehost', :color => 'orange'},
]

spot_statuses.each do |row|
  SpotStatus.find_or_create_by(id: row[:id]).update(row)
end

hosting_sessions = [
  {:id => 1, :name => 'Christmas 2018', :short_name => '18C', :begins => '2018-12-01', :public => true},
  {:id => 2, :name => 'Summer 2018', :short_name => '18S', :begins => '2018-07-01', :public => false},
]

hosting_sessions.each do |row|
  HostingSession.find_or_create_by(id: row[:id]).update(row)
end

# let's try and suck in stuff from output.yml
@ignore_filenames = [
  'Slide1.JPG',
  'Slide3.JPG',
  'Contact Us.jpg',
]

@children = YAML.load(File.read('output.yml'))

puts "Read #{@children.count} records"

Child.delete_all
SessionSpot.delete_all

@children.each do |child|
  next unless child[:description]
  next if @ignore_filenames.include? child[:filename]
  pp child
  
  # let's find any child ID's
  ids = []
  
  child[:description].scan(/(U|UK|L|\ )\s?(\d{3,4})/) do |match|
    next unless ['U','L','UK',' '].include? match[0] 
    next if ['2018','2017'].include? match[1]
    match[0] = 'U' if match[0] == 'UK'
    if match[0] == ' '
      if ids.count > 0
        id = "#{ids[0][0]}#{match[1]}"
      else
        id = "?#{match[1]}"
      end
    else
      id = "#{match[0]}#{match[1]}"
    end
    next if ids.include? id
    ids << id
  end
  
  scholarship = 0
  match = /\$(\d{2,4})\s+scholarship/i.match( child[:description] )
  if match
    scholarship = match[1].to_i
  end
  
  country = ''
  country = 'Ukraine' if ids.first =~ /^U/
  country = 'Latvia' if ids.first =~ /^L/
  
  names = []
  child[:description].scan(/\"([A-Z])\"/) do |match|
    names << match[1]
  end

  status = 1 #available
  status = 2 if child[:description].truncate(60, separator: /\s/) =~ /hold/i
  status = 3 if child[:description].truncate(60, separator: /\s/) =~ /re.?host/i
  

  record = {
    :name => ids.join(', '),
    :scholarship => scholarship,
    :country => country,
    :status => status,
  }
  
  case ids.count
  when 1
    record[:size] = "Single"
  when 2
    record[:size] = "Sibling Pair"
  when 3
    record[:size] = "Sibling Group"
  end
  
  
  
  
  
  @child = Child.find_or_create_by(notes: child[:id])
  @child.update( {:name => record[:name] } )
  @child.update( {:country => record[:country] } )
  @child.update( {:size => record[:size] } )

  @spot = SessionSpot.where(child_id: @child.id).where(hosting_session_id: 1)
  @spot = SessionSpot.create!({:child_id => @child.id, :hosting_session_id => 1, :spot_status_id => record[:status] }) if @spot.empty?
  
  @spot.update( {:scholarship => record[:scholarship] } )
  @spot.update( {:public_notes => child[:description] } )
  
  pp @child
  pp @spot
  
end