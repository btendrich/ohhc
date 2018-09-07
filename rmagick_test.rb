#!/usr/bin/env ruby
require 'rmagick'
require 'pp'

ENLARGEMENT_FACTOR = 1.5


BoundingBox = Struct.new(:width, :height, :left, :top)

faces = [
BoundingBox.new( 0.2487500011920929, 0.28489619493484497, 0.5043749809265137, 0.14459556341171265),
BoundingBox.new( 0.24375000596046448, 0.27916964888572693, 0.09187500178813934, 0.16320687532424927),
]

abort "Usage: #{$0} <path/to/image.jpg>" unless ARGV[0]

image = Magick::ImageList.new( ARGV[0] )

puts image.columns

puts "Found #{faces.count} faces"

if faces.count > 1
  
  faces_in_pixels = []
  faces.each do |face|
    faces_in_pixels << BoundingBox.new( face.width * image.columns, face.height * image.rows, face.left * image.columns, face.top * image.rows )
  end

  bounding_box_in_pixels = BoundingBox.new( 0, 0, 0, 0 )

  faces_in_pixels.each do |face|
    puts "Face found inside box: "
    pp face
    puts
    
    # look at the top/left parameters first
    bounding_box_in_pixels.top = face.top if face.top > bounding_box_in_pixels.top
    bounding_box_in_pixels.left = face.left if face.left > bounding_box_in_pixels.left
    
  
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

    ### add each piece if it's the largest one of the group to build out the full size bounding box
  end

else
  bounding_box = faces.first
  bounding_box_in_pixels = BoundingBox.new( bounding_box.width * image.columns, bounding_box.height * image.rows, bounding_box.left * image.columns, bounding_box.top * image.rows)
end


puts "All faces are inside bounding box: "
pp bounding_box_in_pixels
puts

#abort

#bounding_box_in_pixels = BoundingBox.new( bounding_box.width * image.columns, bounding_box.height * image.rows, bounding_box.left * image.columns, bounding_box.top * image.rows)


cropped = image.crop( bounding_box_in_pixels.left, bounding_box_in_pixels.top, bounding_box_in_pixels.width, bounding_box_in_pixels.height )

cropped.write('output.jpg')

pp bounding_box_in_pixels

enlarged_bounding_box_in_pixels = BoundingBox.new

# modify the bounding box by enlarging (or reduing) it by a factor of ENLARGEMENT_FACTOR
puts "Enlarge the bounding box by #{bounding_box_in_pixels.width * (ENLARGEMENT_FACTOR-1)} and #{bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1)} pixels"
enlarged_bounding_box_in_pixels.width = bounding_box_in_pixels.width * ENLARGEMENT_FACTOR
enlarged_bounding_box_in_pixels.height = bounding_box_in_pixels.height * ENLARGEMENT_FACTOR
# modify the bounding box by shifting it left and up by half the enlargement factor
enlarged_bounding_box_in_pixels.top = bounding_box_in_pixels.top - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
enlarged_bounding_box_in_pixels.left = bounding_box_in_pixels.left - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
puts "Shift the bounding box left by #{(bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2} pixels"
pp enlarged_bounding_box_in_pixels

cropped = image.crop( enlarged_bounding_box_in_pixels.left, enlarged_bounding_box_in_pixels.top, enlarged_bounding_box_in_pixels.width, enlarged_bounding_box_in_pixels.height )

cropped.write('output2.jpg')

resized = cropped.resize_to_fit(256,256)

resized.write('output3.jpg')

puts "make the image square"

if enlarged_bounding_box_in_pixels.width > enlarged_bounding_box_in_pixels.height 
  # expand height to make cropped image square
else
  # expand width to make cropped image square
end

puts "Wrote output.jpg"