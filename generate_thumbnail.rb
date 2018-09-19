#!/usr/bin/env ruby
require 'pp'
require 'rmagick'
require 'dotenv'
require 'aws-sdk'

ENLARGEMENT_FACTOR = 1.5
OUTPUT_SIZE = [256,256]


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



class BoundingBox
  attr_accessor :width, :height, :left, :top

  def initialize( width: nil, height: nil, left: nil, top: nil)
    @width = width
    @height = height
    @left = left
    @top = top
  end
  
end

image = Magick::ImageList.new( ARGV[0] )
image.auto_orient!

puts image.columns

puts "Found #{faces.count} faces"

if faces.count > 1
  
  faces_in_pixels = []
  faces.each do |face|
    faces_in_pixels << BoundingBox.new( width: face.width * image.columns, height: face.height * image.rows, left: face.left * image.columns, top: face.top * image.rows )
  end

  bounding_box_in_pixels = BoundingBox.new( width: 0, height: 0, left: image.columns, top: image.rows )

  faces_in_pixels.each do |face|
    puts "Face found inside box: "
    pp face
    puts
    
    # look at the top/left parameters first
    bounding_box_in_pixels.top = face.top if face.top < bounding_box_in_pixels.top
    bounding_box_in_pixels.left = face.left if face.left < bounding_box_in_pixels.left
    
  
    # calculate the current right side value and the potential right side value
    current_right = bounding_box_in_pixels.left + bounding_box_in_pixels.width
    new_right = face.left + face.width
    puts "Current right side is #{current_right}, compared left is #{new_right}"
    if new_right > current_right
      bounding_box_in_pixels.width = new_right - bounding_box_in_pixels.width
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
  bounding_box_in_pixels = BoundingBox.new( width: bounding_box.width * image.columns, height: bounding_box.height * image.rows, left: bounding_box.left * image.columns, top: bounding_box.top * image.rows)
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

resized = cropped.resize_to_fit(OUTPUT_SIZE[0],OUTPUT_SIZE[0])

resized.write('output3.jpg')

puts "make the image square"

square_bounding_box = BoundingBox.new

puts "Bounding box size is: #{enlarged_bounding_box_in_pixels.width} x #{enlarged_bounding_box_in_pixels.height}"

if enlarged_bounding_box_in_pixels.width > enlarged_bounding_box_in_pixels.height 
  # expand height to make cropped image square
  needed_pixels = enlarged_bounding_box_in_pixels.width - enlarged_bounding_box_in_pixels.height
  pixels_available_above = enlarged_bounding_box_in_pixels.top
  pixels_available_below = image.rows - enlarged_bounding_box_in_pixels.top - enlarged_bounding_box_in_pixels.height
  
  puts "Need to gain #{needed_pixels} pixels in height and have #{pixels_available_above} above and #{pixels_available_below} below"
  # there are three possible conditions here-- 
  # 1 - there are enough pixels above and below to just expand by 1/2 of the needed pixels
  # 2 - there are not enough pixels above to expand
  # 3 - there are not enough pixels below to expand
  # 4 - there are not enough pixels above and below to expand
  if pixels_available_above > (needed_pixels/2) and pixels_available_below > (needed_pixels/2)
    # i have enough pixels above and below to keep everything centered
    puts 'i have enough pixels above and below to keep everything centered'
    square_bounding_box.top = enlarged_bounding_box_in_pixels.top - (needed_pixels/2)
    square_bounding_box.height = enlarged_bounding_box_in_pixels.height + (needed_pixels/2)
  elsif pixels_available_above > (needed_pixels/2)
    # i have enough pixels above only -- will use all pixels below and equal number above to keep centered
    puts 'i have enough pixels above only -- will use all pixels below and equal number above to keep centered'
    square_bounding_box.top = enlarged_bounding_box_in_pixels.top - pixels_available_below
    square_bounding_box.height = enlarged_bounding_box_in_pixels.height + pixels_available_below*2
  elsif pixels_available_below > (needed_pixels/2)
    # i have enough pixels below only -- will use all pixels above and equal number below to keep centered
    puts 'i have enough pixels below only -- will use all pixels above and equal number below to keep centered'
    square_bounding_box.top = enlarged_bounding_box_in_pixels.top - pixels_available_above
    square_bounding_box.height = enlarged_bounding_box_in_pixels.height + pixels_available_above*2
  else
    # i don't have enough pixels above or below to expand -- use the most available in either space and equal on the other side to keep centered
    puts 'i don\'t have enough pixels above or below to expand -- use the most available in either space and equal on the other side to keep centered'
    pixels = pixels_available_above > pixels_available_below ? pixels_available_below : pixels_available_above
    square_bounding_box.top = enlarged_bounding_box_in_pixels.top - (pixels/2)
    square_bounding_box.height = enlarged_bounding_box_in_pixels.height + (pixels/2)
  end
  
  # width and position of the box stay the same
  square_bounding_box.width = enlarged_bounding_box_in_pixels.width
  square_bounding_box.left = enlarged_bounding_box_in_pixels.left
elsif enlarged_bounding_box_in_pixels.width < enlarged_bounding_box_in_pixels.height
  # expand width to make cropped image square
  needed_pixels = enlarged_bounding_box_in_pixels.height - enlarged_bounding_box_in_pixels.width
  pixels_available_left = enlarged_bounding_box_in_pixels.left
  pixels_available_right = image.cols - enlarged_bounding_box_in_pixels.left - enlarged_bounding_box_in_pixels.width
  
  puts "Need to gain #{needed_pixels} pixels in width and have #{pixels_available_left} left and #{pixels_available_right} right"
  # there are three possible conditions here-- 
  # 1 - there are enough pixels left and right to just expand by 1/2 of the needed pixels
  # 2 - there are not enough pixels left to expand
  # 3 - there are not enough pixels right to expand
  # 4 - there are not enough pixels left and right to expand
  if pixels_available_left > (needed_pixels/2) and pixels_available_right > (needed_pixels/2)
    # i have enough pixels left and right to keep everything centered
    puts 'i have enough pixels left and right to keep everything centered'
    square_bounding_box.left = enlarged_bounding_box_in_pixels.left - (needed_pixels/2)
    square_bounding_box.width = enlarged_bounding_box_in_pixels.width + (needed_pixels/2)
  elsif pixels_available_left > (needed_pixels/2)
    # i have enough pixels left only -- will use all pixels right and equal number left to keep centered
    puts 'i have enough pixels left only -- will use all pixels right and equal number left to keep centered'
    square_bounding_box.left = enlarged_bounding_box_in_pixels.left - pixels_available_right
    square_bounding_box.width = enlarged_bounding_box_in_pixels.width + pixels_available_right*2
  elsif pixels_available_right > (needed_pixels/2)
    # i have enough pixels right only -- will use all pixels left and equal number right to keep centered
    puts 'i have enough pixels right only -- will use all pixels left and equal number right to keep centered'
    square_bounding_box.left = enlarged_bounding_box_in_pixels.left - pixels_available_left
    square_bounding_box.width = enlarged_bounding_box_in_pixels.width + pixels_available_left*2
  else
    # i don't have enough pixels left or right to expand -- use the most available in either space and equal on the other side to keep centered
    puts 'i don\'t have enough pixels left or right to expand -- use the most available in either space and equal on the other side to keep centered'
    pixels = pixels_available_left > pixels_available_right ? pixels_available_right : pixels_available_left
    square_bounding_box.left = enlarged_bounding_box_in_pixels.left - (pixels/2)
    square_bounding_box.width = enlarged_bounding_box_in_pixels.width + (pixels/2)
  end

  # height and position of the box stay the same
  square_bounding_box.height = enlarged_bounding_box_in_pixels.height
  square_bounding_box.top = enlarged_bounding_box_in_pixels.top
end

cropped = image.crop( square_bounding_box.left, square_bounding_box.top, square_bounding_box.width, square_bounding_box.height )
resized = cropped.resize_to_fit(OUTPUT_SIZE[0],OUTPUT_SIZE[0])

resized.write('output4.jpg')


puts "Wrote output.jpg"