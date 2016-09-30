require 'fastimage/resize'

# https://github.com/sdsykes/fastimage_resize
# https://github.com/planio-gmbh/local-fastimage_resize/blob/master/README.textile
# https://github.com/planio-gmbh/local-fastimage_resize

FastImage.resize("/Users/mark/RubymineProjects/photo-renamer/images/folder.jpg", 100, 100,
                 outfile: "/Users/mark/RubymineProjects/photo-renamer/images/small_folder.jpg")
