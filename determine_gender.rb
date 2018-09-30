#!/usr/bin/env ruby
require 'pp'
require 'dotenv'
require 'pg'

@boy_words = %w{he his boy}
@girl_words = %w{she her girl}

@conn = PG.connect( dbname: 'ohhc-development' )

@conn.exec( "SELECT * FROM children WHERE gender = ''" ) do |result|
  puts "There are #{result.count} children with blank gender fields."
  result.each do |row|
    
    @conn.exec( "SELECT * FROM session_spots WHERE child_id = $1", [row['id']] ) do |result|
      if result.count == 1
        row2 = result.first
        description = row2['public_notes']
        
        
        puts "Look at child id #{row['id']} whose description is #{row2['public_notes']}"
        
        description.downcase!
        
        male = 0.0
        @boy_words.each {|word| male = male + description.scan(/(?= #{word} )/).count }
        
        female = 0.0
        @girl_words.each {|word| female = female + description.scan(/(?= #{word} )/).count }

        total = male + female
        if total == 0
          puts "------ No hits, moving on"
          puts
          next
        end
        
        male_percentage = male / total
        female_percentage = female / total
            
        if male_percentage > 0.8
          puts "------ Male percentage of #{male_percentage}"
          @conn.exec( "UPDATE children SET gender = 'Male' WHERE id = $1", [row['id']])
        elsif female_percentage > 0.8
          puts "------ Female percentage of #{female_percentage}"
          @conn.exec( "UPDATE children SET gender = 'Female' WHERE id = $1", [row['id']])
        else
          puts "------ Inconclusive (#{male_percentage} vs #{female_percentage})"
        end
        
        puts
      end
    end
  end
end
