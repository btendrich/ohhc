#!/usr/bin/env ruby
require 'pp'
require 'json'
require 'yaml'

@NEXT_PAGE = ''
ALBUM_ID='AJqmgamaDiLIV0JNGvzgag7i20sgc7uoOw4TG0-rX4MsDU1PF_PjVT5z--KsULptlI5fiU0RmcQlaH88Nkzs2AUtbCBC8sSUtQ'
AUTH_TOKEN='ya29.GmQnBqaVDnDrPzJXVDnY6xurTG0bc9b4b6MApdo9cH0R8Qs-zieHQUNTrtmcn5a8sn0xrIX4twruPixDiSaAOuRZIbkpleRpr8FCS5O3wHHXfBpyLJnvW5BqVE3cVumRDi72BP_e'
URL=%q(curl -s 'https://content-photoslibrary.googleapis.com/v1/mediaItems:search?alt=json&key=AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw' --compressed -XPOST -H 'Content-Type: application/json' -H 'Origin: https://content-photoslibrary.googleapis.com' -H 'Authorization: Bearer AUTH_TOKEN' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15' -H 'Referer: https://content-photoslibrary.googleapis.com/static/proxy.html?usegapi=1&jsh=m%3B%2F_%2Fscs%2Fapps-static%2F_%2Fjs%2Fk%3Doz.gapi.en.DrNyMm3Q1ZY.O%2Fam%3DwQ%2Frt%3Dj%2Fd%3D1%2Frs%3DAGLTcCMuhz577cTMw4ztjzQYvGEBWKxcKw%2Fm%3D__features__' -H 'X-Requested-With: XMLHttpRequest' -H 'X-Goog-Encode-Response-If-Executable: base64' -H 'X-Origin: https://explorer.apis.google.com' -H 'X-ClientDetails: appVersion=5.0%20(Macintosh%3B%20Intel%20Mac%20OS%20X%2010_13_6)%20AppleWebKit%2F605.1.15%20(KHTML%2C%20like%20Gecko)%20Version%2F11.1.2%20Safari%2F605.1.15&platform=MacIntel&userAgent=Mozilla%2F5.0%20(Macintosh%3B%20Intel%20Mac%20OS%20X%2010_13_6)%20AppleWebKit%2F605.1.15%20(KHTML%2C%20like%20Gecko)%20Version%2F11.1.2%20Safari%2F605.1.15' -H 'X-JavaScript-User-Agent: apix/3.0.0 google-api-javascript-client/1.1.0' -H 'X-Referer: https://explorer.apis.google.com' --data-binary '{"albumId":"ALBUM_ID"PAGE_TOKEN}')

@ignore_filenames = [
  'Slide1.JPG',
  'Slide2.JPG',
  'Slide3.JPG',
  'Slide4.JPG',
  'Slide5.JPG',
  'Slide6.JPG',
  'Slide7.JPG',
  'Slide8.JPG',
  'Slide9.JPG',
  'Slide10.JPG',
  'Slide11.JPG',
  'Slide12.JPG',
  'Contact Us.JPG',
]

# begin loop here
loop_count = 1
@photos = []

loop do
  break if loop_count > 10
  puts "Request loop number #{loop_count}"

  @PAGE_TOKEN= @NEXT_PAGE == '' ? '' : ",\"pageToken\":\"#{@NEXT_PAGE}\""

  req = URL.gsub('ALBUM_ID', ALBUM_ID).gsub('AUTH_TOKEN',AUTH_TOKEN).gsub('PAGE_TOKEN',@PAGE_TOKEN)
  json = %x(#{req})
  response = JSON.parse(json)
  
  break if not response['mediaItems']
  
  puts "Received #{response['mediaItems'].count} images."
  puts "First image name is #{response['mediaItems'].first['filename']}"
  
  response['mediaItems'].each do |photo|
    next if @ignore_filenames.include? photo['filename']
    @photos << {
      :id => photo['id'],
      :filename => photo['filename'],
      :description => photo['description'],
      :url => photo['baseUrl']
    }
  end
  
  puts "Now I have #{@photos.count} photos."
  
  
  break if response['nextPageToken'] == nil || response['nextPageToken'] == ''
  @NEXT_PAGE=response['nextPageToken']
  puts "Got a next page token... moving on"
  sleep 1

#  abort
  loop_count = loop_count + 1
end

#puts @photos

#puts @photos.to_yaml

File.write('output.yml', @photos.to_yaml)
puts "Wrote #{@photos.count} photos to output.yaml"