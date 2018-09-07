#!/usr/bin/env ruby
require 'pp'
require 'rmagick'
require 'dotenv'
require 'aws-sdk'

ENLARGEMENT_FACTOR = 1.5


Dotenv.load


abort "Usage: #{$0} <path/to/image.jpg>" unless ARGV[0]


output_file = /^(.+)\.(.{3})$/.match(ARGV[0])[1]
output_file = output_file + "_tn.jpg"
#abort "output is #{output_file}"

client = Aws::Rekognition::Client.new

resp = client.detect_faces( image: { bytes: File.read(ARGV.first) } )

faces = []

resp.face_details.each do |face|
  faces << face.bounding_box
end


BoundingBox = Struct.new(:width, :height, :left, :top)

image = Magick::ImageList.new( ARGV[0] )

image.auto_orient!

pp image

if faces.count > 1

  faces_in_pixels = []
  faces.each do |face|
    faces_in_pixels << BoundingBox.new( face.width * image.columns, face.height * image.rows, face.left * image.columns, face.top * image.rows )
  end

  bounding_box_in_pixels = BoundingBox.new( 0, 0, image.rows, image.columns )

  faces_in_pixels.each do |face|
    # look at the top/left parameters first
    bounding_box_in_pixels.top = face.top if face.top < bounding_box_in_pixels.top
    bounding_box_in_pixels.left = face.left if face.left < bounding_box_in_pixels.left
  
    # calculate the current right side value and the potential right side value
    current_right = bounding_box_in_pixels.left + bounding_box_in_pixels.width
    new_right = face.left + face.width
    if new_right > current_right
      bounding_box_in_pixels.width = new_right - bounding_box_in_pixels.left
    end
  
    current_top = bounding_box_in_pixels.top + bounding_box_in_pixels.height
    new_top = face.top + face.height
    if new_top > current_top
      bounding_box_in_pixels.height = new_top - bounding_box_in_pixels.top
    end

  end

else
  bounding_box = faces.first
  bounding_box_in_pixels = BoundingBox.new( bounding_box.width * image.columns, bounding_box.height * image.rows, bounding_box.left * image.columns, bounding_box.top * image.rows)
end



enlarged_bounding_box_in_pixels = BoundingBox.new

# modify the bounding box by enlarging (or reduing) it by a factor of ENLARGEMENT_FACTOR
enlarged_bounding_box_in_pixels.width = bounding_box_in_pixels.width * ENLARGEMENT_FACTOR
enlarged_bounding_box_in_pixels.height = bounding_box_in_pixels.height * ENLARGEMENT_FACTOR
# modify the bounding box by shifting it left and up by half the enlargement factor
enlarged_bounding_box_in_pixels.top = bounding_box_in_pixels.top - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
enlarged_bounding_box_in_pixels.left = bounding_box_in_pixels.left - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2

cropped = image.crop( enlarged_bounding_box_in_pixels.left, enlarged_bounding_box_in_pixels.top, enlarged_bounding_box_in_pixels.width, enlarged_bounding_box_in_pixels.height )
resized = cropped.resize_to_fit(256,256)

resized.write(output_file)
puts "Wrote #{output_file}"