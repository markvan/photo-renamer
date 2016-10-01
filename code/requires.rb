require 'fileutils'

Shoes.setup do
  gem 'rspec'
  gem 'exifr'
  gem 'fastimage'
  gem 'image_science'
end
require 'image_science'

def ruby_root
  __dir__.gsub(/\/code/, '')
end

['/controller', '/image', '/directory', '/image_file_name', '/check_exif'].each do |name|
  require __dir__+name
end