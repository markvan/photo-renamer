class Controller

  attr_reader :image

  def slf=(obj)
    @shoes=obj
  end

  def dir
    @shoes.set_image('/Users/mark/RubymineProjects/photo-renamer/spec/image_setup/2005-05-09 23.17.59.jpg')
  end

  def ruby_root
    __dir__.gsub(/\/code/,'')
  end

  def test
    setup_dir(Directory.test_dir)
  end

  def setup_dir(dir)
    @dir = (dir =~ /\/$/ ? dir : dir + '/')
    @image = Image.new(@dir)
    @shoes.set_image(@image.next)
  end

  def previous
    @shoes.set_image(@image.previous)
  end

  def next
    @shoes.set_image(@image.next)
  end

end