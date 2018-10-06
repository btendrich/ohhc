# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'CSV'

hosting_sessions = [
  {:id => 1, :name => 'Christmas 2018', :date => '2018-12-01', :public => true},
  {:id => 2, :name => 'Summer 2018', :date => '2018-07-01', :public => false},
]

hosting_sessions.each do |row|
  HostingSession.find_or_create_by(id: row[:id]).update(row)
end

HostingSession.connection.execute("ALTER SEQUENCE hosting_sessions_id_seq RESTART WITH #{hosting_sessions.count + 1}")

spot_statuses = [
  {:id => 1, :name => 'Available', :public => true},
  {:id => 2, :name => 'On-Hold', :public => true},
  {:id => 3, :name => 'Hosted', :public => true},
  {:id => 4, :name => 'Rehost', :public => true},
  {:id => 5, :name => 'Administrative Hold', :public => false},
  {:id => 6, :name => 'Unknown', :public => false},
]

spot_statuses.each do |row|
  SpotStatus.find_or_create_by(id: row[:id]).update(row)
end

SpotStatus.connection.execute("ALTER SEQUENCE hosting_sessions_id_seq RESTART WITH #{hosting_sessions.count + 1}")

@urls = []

puts "Processing airtable.csv (from airtable)"

@airtable = []
@headers = nil
CSV.read("airtable.csv", :headers => true, :header_converters => :symbol).each do |row|
  @child = Child.find_by_identifier(row[:id])
  @child = Child.new({:identifier => row[:id]}) if @child.nil?
  @child.save
  

  status = -1
  if row[:hosting_status] =~ /confirmed/i
    status = 3
  elsif row[:hosting_status] =~ /pending/i
    status = 2
  elsif row[:hosting_status] =~ /rehost/i
    status = 4
  else
    if row[:offer] =~ /yes/i
      status = 1
    end
  end
  
  if status != -1
    @hosting_session_spot = HostingSessionSpot.includes(:hosting_session_spot_children).where( "hosting_session_spot_children.child_id = ?", @child.id ).where(:hosting_session_id => 1).references(:hosting_session_spot_children).first
    if @hosting_session_spot.nil?
      @hosting_session_spot = HostingSessionSpot.new()
      @hosting_session_spot.status_id = status
      @hosting_session_spot.hosting_session_id = 1
      @hosting_session_spot.save!
      
      @hosting_session_spot_child = HostingSessionSpotChild.new()
      @hosting_session_spot_child.child_id = @child.id
      @hosting_session_spot_child.hosting_session_spot_id = @hosting_session_spot.id
      @hosting_session_spot_child.save
    end
    
    @hosting_session_spot.status_id = status
    @hosting_session_spot.hosting_session_id = 1
    @hosting_session_spot.scholarship = /(\d+)/.match(row[:scholarship])[1] if row[:scholarship] =~ /\d+/
    @hosting_session_spot.save!

  end

  if row[:s18_hf].presence
    string = row[:s18_hf].gsub(/\(|\)|\,/,'')
    name = nil
    state = nil
    if matches = /([a-zA-Z]+)\W+(\w{2})$/.match( string )
      name = matches[1].capitalize
      state = matches[2].upcase
    elsif
      matches = /([a-zA-Z]+)/.match( string )
      name = matches[1].capitalize
    else
      abort "Don't know how to handle '#{string}'"
    end
    @family = Family.where(:last_name => name, :state => state ).first
    @family = Family.new({:last_name => name, :state => state}) if @family.nil?
    @family.save
    
    @hosting_session_spot = HostingSessionSpot.includes(:hosting_session_spot_children).where( "hosting_session_spot_children.child_id = ?", @child.id ).where(:hosting_session_id => 2).references(:hosting_session_spot_children).first
    @hosting_session_spot = HostingSessionSpot.new({:family_id => @family.id, :hosting_session_id => 2}) if @hosting_session_spot.nil?
    @hosting_session_spot.family_id = @family.id
    @hosting_session_spot.status_id = 3
    @hosting_session_spot.save!
    
    @hosting_session_spot_child = HostingSessionSpotChild.where(:child_id => @child.id, :hosting_session_spot_id => @hosting_session_spot.id ).first
    @hosting_session_spot_child = HostingSessionSpotChild.new({:child_id => @child.id, :hosting_session_spot_id => @hosting_session_spot.id}) if @hosting_session_spot_child.nil?
    @hosting_session_spot_child.save!
    
  end

  if row[:c18_hf].presence
    string = row[:c18_hf].gsub(/\(|\)|\,/,'')
    name = nil
    state = nil
    if matches = /([a-zA-Z]+)\W+(\w{2})$/.match( string )
      name = matches[1].capitalize
      state = matches[2].upcase
    elsif
      matches = /([a-zA-Z]+)/.match( string )
      name = matches[1].capitalize
    else
      abort "Don't know how to handle '#{string}'"
    end
    @family = Family.where(:last_name => name, :state => state ).first
    @family = Family.new({:last_name => name, :state => state}) if @family.nil?
    @family.save
    
    @hosting_session_spot = HostingSessionSpot.includes(:hosting_session_spot_children).where( "hosting_session_spot_children.child_id = ?", @child.id ).where(:hosting_session_id => 1).references(:hosting_session_spot_children).first
    @hosting_session_spot = HostingSessionSpot.new({:family_id => @family.id, :hosting_session_id => 1}) if @hosting_session_spot.nil?
    @hosting_session_spot.family_id = @family.id
    @hosting_session_spot.status_id = status
    @hosting_session_spot.save
    
    @hosting_session_spot_child = HostingSessionSpotChild.where(:child_id => @child.id, :hosting_session_spot_id => @hosting_session_spot.id ).first
    @hosting_session_spot_child = HostingSessionSpotChild.new({:child_id => @child.id, :hosting_session_spot_id => @hosting_session_spot.id}) if @hosting_session_spot_child.nil?
    @hosting_session_spot_child.save
    
  end
  
  @child.first_name = row[:first_name]
  @child.last_name = row[:last_name]
  @child.birthday = row[:dob]
  @child.sibling_notes = row[:siblings]
  @child.orphanage = row[:orphanageorphan_court]
  @child.legal_status = row[:legal_status]
  @child.save
  
  if row[:comment].presence
    @notes = ChildNote.where(child_id: @child.id, text: row[:comment]).first
    @notes = ChildNote.new({:child_id => @child.id, :text => row[:comment]}) if @notes.nil?
    @notes.title = "From AirTable"
    @notes.text = row[:comment]
    @notes.save
  end

  if row[:addl_notes].presence
    @notes = ChildNote.where(child_id: @child.id, text: row[:addl_notes]).first
    @notes = ChildNote.new({:child_id => @child.id, :text => row[:addl_notes]}) if @notes.nil?
    @notes.title = "From AirTable"
    @notes.text = row[:addl_notes]
    @notes.save
  end
  
  if row[:photo]
    row[:photo].split(',').each do |photo|
      match = /^(.+)\((\S+)\)$/.match(photo)
      abort "Unknown photo line format '#{photo}'" unless match[2]
      filename = match[1]
      url = match[2]
      
      match = /^https.+\/(\w+)\_\S+$/.match(url)
      abort "Unknown photo line format '#{photo}'" unless match[1]
      airtable_id = match[1]
      
#      puts "Photo with UID #{airtable_id} is at #{url}"
      
      @photo = ChildFile.where(child_id: @child.id, description: airtable_id).first
      @photo = ChildFile.new({:child_id => @child.id, :description => airtable_id}) if @photo.nil?
      @photo.filename = filename
      @photo.type = "image/jpeg"
      @photo.key = url
      @photo.public = true
      @photo.save

    end
  end

  if row[:interview_sheet]
    row[:interview_sheet].split(',').each do |photo|
      match = /^(.+)\((\S+)\)$/.match(photo)
      abort "Unknown interview_sheet line format '#{photo}'" unless match[2]
      filename = match[1]
      url = match[2]
      
      match = /^https.+\/(\w+)\_\S+$/.match(url)
      abort "Unknown interview_sheet line format '#{photo}'" unless match[1]
      airtable_id = match[1]
      
#      puts "Interview sheet with UID #{airtable_id} is at #{url}"
      
      @photo = ChildFile.where(child_id: @child.id, description: airtable_id).first
      @photo = ChildFile.new({:child_id => @child.id, :description => airtable_id}) if @photo.nil?
      @photo.filename = filename
      @photo.type = "image/jpeg"
      @photo.key = url
      @photo.public = true
      @photo.save

    end
  end
  
#  pp row  
end



puts "Processing output.yml (from google photos)"


@ignore_filenames = [
  'Slide1.JPG',
  'Slide3.JPG',
  'Contact Us.jpg',
]

@children = YAML.load(File.read('output.yml'))

puts "Read #{@children.count} records"

@children.each do |child|
  next unless child[:description]
  next if @ignore_filenames.include? child[:filename]
#  pp child
  
  # let's find any child ID's
  ids = []
  
  child[:description].scan(/(U|UK|L|\ )?\s?(\d{3,4})/) do |match|
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
  
  next unless ids.count > 0
  
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
  status = 4 if child[:description].truncate(60, separator: /\s/) =~ /re.?host/i
  

  size = "Unknown"
  case ids.count
  when 1
    size = "Single"
  when 2
    size = "Sibling Pair"
  when 3
    size = "Sibling Group"
  end
  
  
  puts "Looking at child #{ids} and #{names}"
  
  ids.each do |id|
    number = /(\d{3,4})/.match(id)[1]
    @child = Child.find_by_identifier(number)
 
    next unless @child
    @child.country = country if country.presence
    
    @spot = @child.hosting_session_spots.where(hosting_session_id: 1).first
    next unless @spot
    
    puts "Found child and session spot"
    
    @spot.status_id = status if status
    @spot.scholarship = scholarship
    
    if @spot.description
      next if @spot.description.include? child[:description]
      @spot.description = @spot.description + "\n\n" + child[:description]
    else
      @spot.description = child[:description]
    end
      

    @child.save
    @spot.save
    
  end
  
  
#  @child = Child.find_or_create_by(notes: child[:id])
#  @child.update( {:name => record[:name] } )
#  @child.update( {:country => record[:country] } )
#  @child.update( {:size => record[:size] } )

#  @spot = SessionSpot.where(child_id: @child.id).where(hosting_session_id: 1)
#  @spot = SessionSpot.create!({:child_id => @child.id, :hosting_session_id => 1, :spot_status_id => record[:status] }) if @spot.empty?
  
#  @spot.update( {:scholarship => record[:scholarship] } )
#  @spot.update( {:public_notes => child[:description] } )
  
#  pp @child
#  pp @spot
  
end




=begin

spot_statuses = [
  {:id => 1, :name => 'Available', :color => '#1E9A1E'},
  {:id => 2, :name => 'On-Hold', :color => 'orange'},
  {:id => 3, :name => 'Rehost', :color => 'orange'},
]

spot_statuses.each do |row|
  SpotStatus.find_or_create_by(id: row[:id]).update(row)
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

=end
