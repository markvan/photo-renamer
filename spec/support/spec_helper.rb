require 'tk'
require 'tkextlib/tkimg'
def ruby_root
  __dir__.gsub(/spec\/support$/,'')
end
require ruby_root+'code/view'
require ruby_root+'code/image'
require ruby_root+'code/image_file_name'