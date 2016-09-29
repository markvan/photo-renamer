require 'fileutils'
require 'tk'
require 'tkextlib/tkimg'

def ruby_root
  __dir__.gsub(/\/code/, '')
end

['/image', '/view', '/image_file_name', '/check_exif'].each do |name|
  require __dir__+name
end