require 'mini_magick'


image = MiniMagick::Image.open("/Users/mark/RubymineProjects/photo-renamer/images/folder.jpg")
image.path
image.resize "100x100"
image.format "png"
image.write "/Users/mark/RubymineProjects/photo-renamer/images/small_folder.jpg"