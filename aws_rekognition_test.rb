#!/usr/bin/env ruby
require 'pp'

require 'dotenv'
Dotenv.load

require 'aws-sdk'


abort "Usage: #{$0} <path/to/image.jpg>" unless ARGV[0]

client = Aws::Rekognition::Client.new

resp = client.detect_faces( image: { bytes: File.read(ARGV.first) } )


pp resp

puts "------------------------------------------------"

resp.face_details.each do |face|
  puts "Face:"
  pp face.bounding_box
  puts
  puts
end


