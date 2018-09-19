#!/usr/bin/env ruby
require 'rmagick'
require 'pp'
require 'dotenv'
require 'aws-sdk'

Dotenv.load

ENLARGEMENT_FACTOR = 1.5
OUTPUT_SIZE = [256,256]
SIMULATE = nil

abort "Usage: #{$0} <path/to/image.jpg>" unless ARGV[0]

output_file = /^(.+)\.(.{3})$/.match(ARGV[0])[1]
output_file = output_file + "_tn.jpg"

class Point
  attr_accessor :x, :y
  
  def initialize( x: nil, y: nil )
    @x = x
    @y = y
  end
  
  def to_s
    "Point(object_id: #{"0x00%x" % (object_id << 1)}, x: #{x}, y: #{y})"
  end
end

class BoundingBox
  attr_accessor :width, :height, :left, :top

  def initialize( width: nil, height: nil, left: nil, top: nil)
    @width = width
    @height = height
    @left = left
    @top = top
  end

  def points
    points = []
    points << Point.new(x: left, y: top)
    points << Point.new(x: left+width, y: top)
    points << Point.new(x: left, y: top+height)
    points << Point.new(x: left+width, y: top+height)
    points
  end

  def to_s
    "BoundingBox(object_id: #{"0x00%x" % (object_id << 1)}, width: #{width}, height: #{height}, left: #{left}, top: #{top})"
  end
end

if SIMULATE
  # simualte the AWS calls - for debugging
  if ARGV[0] == 'single.jpg'
    faces = [
      BoundingBox.new( width: 0.2651839256286621, height: 0.19374999403953552, left: 0.34559452533721924, top: 0.09875000268220901),
    ]
  elsif ARGV[0] == 'group.jpg'
    faces = [
      BoundingBox.new( width: 0.22070707380771637, height: 0.3313116133213043, left: 0.19494949281215668, top: 0.22592873871326447),
      BoundingBox.new( width: 0.19343434274196625, height: 0.29037150740623474, left: 0.6484848260879517, top: 0.1645185798406601),
      BoundingBox.new( width: 0.17373737692832947, height: 0.2608036398887634, left: 0.435353547334671, top: 0.3987869620323181),
    ]
  else
    abort "Unable to simulate #{ARGV[0]} -- no sample data"
  end
else
  # lets make actual AWS calls
  client = Aws::Rekognition::Client.new

  resp = client.detect_faces( image: { bytes: File.read(ARGV.first) } )

  faces = []

  resp.face_details.each do |face|
    faces << BoundingBox.new( width: face.bounding_box.width, height: face.bounding_box.height, left: face.bounding_box.left, top: face.bounding_box.top )
  end
end

points = faces.collect {|face| face.points}
points.flatten!

face_box = BoundingBox.new()

# use the minimum and maximim X values to determine the left and width of a box containing all points
points.sort! {|a,b| a.x <=> b.x}
face_box.left = points.first.x
face_box.width = points.last.x - points.first.x

# use the minimum and maximum Y values to determina the top and height of a box containing all points
points.sort! {|a,b| a.y <=> b.y}
face_box.top = points.first.y
face_box.height = points.last.y - points.first.y

puts "Found #{faces.count} faces which generated #{points.count} points. All face points contained within #{face_box}."

# read image
image = Magick::ImageList.new( ARGV[0] )
image.auto_orient!

# convert percentage based bounding box into actual pixels
bounding_box_in_pixels = BoundingBox.new( width: (face_box.width * image.columns).to_i, height: (face_box.height * image.rows).to_i, left: (face_box.left * image.columns).to_i, top: (face_box.top * image.rows).to_i )

puts "Image is #{image.columns}x#{image.rows} and face point bounding box is #{bounding_box_in_pixels}"


#cropped = image.crop( bounding_box_in_pixels.left, bounding_box_in_pixels.top, bounding_box_in_pixels.width, bounding_box_in_pixels.height )

#cropped.write('output.jpg')

#pp bounding_box_in_pixels

enlarged_bounding_box_in_pixels = BoundingBox.new

# modify the bounding box by enlarging (or reduing) it by a factor of ENLARGEMENT_FACTOR
puts "Enlarge the bounding box by #{bounding_box_in_pixels.width * (ENLARGEMENT_FACTOR-1)} and #{bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1)} pixels"
enlarged_bounding_box_in_pixels.width = bounding_box_in_pixels.width * ENLARGEMENT_FACTOR
enlarged_bounding_box_in_pixels.height = bounding_box_in_pixels.height * ENLARGEMENT_FACTOR
# modify the bounding box by shifting it left and up by half the enlargement factor
enlarged_bounding_box_in_pixels.top = bounding_box_in_pixels.top - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
enlarged_bounding_box_in_pixels.left = bounding_box_in_pixels.left - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
puts "Shift the bounding box left by #{(bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2} pixels"
#pp enlarged_bounding_box_in_pixels

cropped = image.crop( enlarged_bounding_box_in_pixels.left, enlarged_bounding_box_in_pixels.top, enlarged_bounding_box_in_pixels.width, enlarged_bounding_box_in_pixels.height )

#cropped.write('output2.jpg')

resized = cropped.resize_to_fit(OUTPUT_SIZE[0],OUTPUT_SIZE[0])

resized.write(output_file)
puts "Wrote #{output_file}"


abort

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
  pixels_available_right = image.columns - enlarged_bounding_box_in_pixels.left - enlarged_bounding_box_in_pixels.width
  
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

resized.write(output_file)
puts "Wrote #{output_file}"


