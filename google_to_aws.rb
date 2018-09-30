#!/usr/bin/env ruby
require 'pp'
require 'rmagick'
require 'dotenv'
##require 'aws-sdk'
require 'aws-sdk-s3'  # v2: require 'aws-sdk'
require 'aws-sdk-rekognition'
require 'pg'
require 'yaml'
require 'open-uri'
require 'tempfile'


ENLARGEMENT_FACTOR = 1.5
OUTPUT_SIZE = [256,256]

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

Dotenv.load

@s3 = Aws::S3::Resource.new(region: 'us-east-1')
@bucket = @s3.bucket('ohhc-photos')

@rekognition = Aws::Rekognition::Client.new

@conn = PG.connect( dbname: 'ohhc-development' )

@google = YAML.load(File.read('output.yml'))

@conn.exec( "SELECT * FROM children WHERE notes != ''" ) do |result|
  result.each do |row|
    
    @conn.exec( "SELECT * FROM child_photos WHERE child_id = $1", [row['id']] ) do |result|
      if result.count == 0
        google = @google.select {|s| s[:id] == row['notes'] }.first
        
        next if google.nil?

        original_image = Magick::ImageList.new( google[:url] + "=d")
        pp original_image

        full_size_tempfile = Tempfile.new.path + ".jpg"
        original_image.write( full_size_tempfile )
        
        med_tempfile = Tempfile.new.path + ".jpg"
        med = original_image.resize_to_fit(600,600)
        med.write( med_tempfile )

        small_tempfile = Tempfile.new.path + ".jpg"
        small = original_image.resize_to_fit(256,256)
        small.write( small_tempfile )

        thumbnail_tempfile = Tempfile.new.path + ".jpg"
        thumbnail = original_image.resize_to_fit(100,100)
        thumbnail.write( thumbnail_tempfile )

        
        uuid = SecureRandom.uuid

        full_size_filename = "#{uuid}.jpg"
        full_size_s3obj = @s3.bucket('ohhc-photos').object(full_size_filename)
        full_size_s3obj.upload_file( full_size_tempfile, acl: 'public-read' )

        med_filename = "#{uuid}_md.jpg"
        med_s3obj = @s3.bucket('ohhc-photos').object(med_filename)
        med_s3obj.upload_file( med_tempfile, acl: 'public-read' )

        small_filename = "#{uuid}_sm.jpg"
        small_s3obj = @s3.bucket('ohhc-photos').object(small_filename)
        small_s3obj.upload_file( small_tempfile, acl: 'public-read' )

        thumbnail_filename = "#{uuid}_tn.jpg"
        thumbnail_s3obj = @s3.bucket('ohhc-photos').object(thumbnail_filename)
        thumbnail_s3obj.upload_file( thumbnail_tempfile, acl: 'public-read' )
        
        @conn.exec( "INSERT INTO child_photos (child_id,description,key,row_order,created_at,updated_at) VALUES ($1, $2, $3, 100000, now(), now())", [row['id'].to_i, google[:filename], uuid])
        
#        File.delete( full_size_tempfile )
        File.delete( med_tempfile )
        File.delete( small_tempfile )
        File.delete( thumbnail_tempfile )


        ################ now let's crop the photo to the face and do it again
        
        # let's generate the face photo now too
        response = @rekognition.detect_faces( image: { bytes: File.read( full_size_tempfile ) } )

        faces = []

        response.face_details.each do |face|
          faces << BoundingBox.new( width: face.bounding_box.width, height: face.bounding_box.height, left: face.bounding_box.left, top: face.bounding_box.top )
        end
        
        pp faces

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


        original_image.auto_orient!

        # convert percentage based bounding box into actual pixels
        bounding_box_in_pixels = BoundingBox.new( width: (face_box.width * original_image.columns).to_i, height: (face_box.height * original_image.rows).to_i, left: (face_box.left * original_image.columns).to_i, top: (face_box.top * original_image.rows).to_i )

        puts "Image is #{original_image.columns}x#{original_image.rows} and face point bounding box is #{bounding_box_in_pixels}"

        enlarged_bounding_box_in_pixels = BoundingBox.new
        # modify the bounding box by enlarging (or reduing) it by a factor of ENLARGEMENT_FACTOR
#        puts "Enlarge the bounding box by #{bounding_box_in_pixels.width * (ENLARGEMENT_FACTOR-1)} and #{bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1)} pixels"
        enlarged_bounding_box_in_pixels.width = bounding_box_in_pixels.width * ENLARGEMENT_FACTOR
        enlarged_bounding_box_in_pixels.height = bounding_box_in_pixels.height * ENLARGEMENT_FACTOR
        # modify the bounding box by shifting it left and up by half the enlargement factor
        enlarged_bounding_box_in_pixels.top = bounding_box_in_pixels.top - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
        enlarged_bounding_box_in_pixels.left = bounding_box_in_pixels.left - (bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2
#        puts "Shift the bounding box left by #{(bounding_box_in_pixels.height * (ENLARGEMENT_FACTOR-1))/2} pixels"
        #pp enlarged_bounding_box_in_pixels

        
        # now there is a new photo -- a cropped face, rebuild the thumbnails and write the cropped images with a new uuid
        uuid = SecureRandom.uuid
        cropped = original_image.crop( enlarged_bounding_box_in_pixels.left, enlarged_bounding_box_in_pixels.top, enlarged_bounding_box_in_pixels.width, enlarged_bounding_box_in_pixels.height )
        
        File.delete( full_size_tempfile )
        
        full_size_tempfile = Tempfile.new.path + ".jpg"
        cropped.write( full_size_tempfile )
        
        med_tempfile = Tempfile.new.path + ".jpg"
        med = cropped.resize_to_fit(600,600)
        med.write( med_tempfile )

        small_tempfile = Tempfile.new.path + ".jpg"
        small = cropped.resize_to_fit(256,256)
        small.write( small_tempfile )

        thumbnail_tempfile = Tempfile.new.path + ".jpg"
        thumbnail = cropped.resize_to_fit(100,100)
        thumbnail.write( thumbnail_tempfile )

        
        uuid = SecureRandom.uuid

        full_size_filename = "#{uuid}.jpg"
        full_size_s3obj = @s3.bucket('ohhc-photos').object(full_size_filename)
        full_size_s3obj.upload_file( full_size_tempfile, acl: 'public-read' )

        med_filename = "#{uuid}_md.jpg"
        med_s3obj = @s3.bucket('ohhc-photos').object(med_filename)
        med_s3obj.upload_file( med_tempfile, acl: 'public-read' )

        small_filename = "#{uuid}_sm.jpg"
        small_s3obj = @s3.bucket('ohhc-photos').object(small_filename)
        small_s3obj.upload_file( small_tempfile, acl: 'public-read' )

        thumbnail_filename = "#{uuid}_tn.jpg"
        thumbnail_s3obj = @s3.bucket('ohhc-photos').object(thumbnail_filename)
        thumbnail_s3obj.upload_file( thumbnail_tempfile, acl: 'public-read' )
        
        @conn.exec( "INSERT INTO child_photos (child_id,description,key,row_order,created_at,updated_at) VALUES ($1, $2, $3, 1, now(), now())", [row['id'].to_i, google[:filename], uuid])

        
        File.delete( full_size_tempfile )
        File.delete( med_tempfile )
        File.delete( small_tempfile )
        File.delete( thumbnail_tempfile )
        
        
#        abort

#        puts url
#        puts SecureRandom.uuid
    
#        abort "fuck, can't match ids" if google.count == 0
      else
        puts "Found #{result.count} photos for this child -- skipping."
      end
    end
  end
end
