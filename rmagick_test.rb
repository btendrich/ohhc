#!/usr/bin/env ruby
require 'rmagick'
require 'pp'

ENLARGEMENT_FACTOR = 1.5


BoundingBox = Struct.new(:width, :height, :left, :top)

bounding_box = BoundingBox.new( 0.2651839256286621, 0.19374999403953552, 0.34559452533721924, 0.09937500208616257)

abort "Usage: #{$0} <path/to/image.jpg>" unless ARGV[0]

pp bounding_box

image = Magick::ImageList.new( ARGV[0] )

pp image

puts image.columns

bounding_box_in_pixels = BoundingBox.new( bounding_box.width * image.columns, bounding_box.height * image.rows, bounding_box.left * image.columns, bounding_box.top * image.rows)


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

puts "Wrote output.jpg"