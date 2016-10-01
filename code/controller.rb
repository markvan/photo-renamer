class Controller

  attr_reader :image

  def shoes=(obj)
    @shoes=obj
  end

  def dir
    setup_dir(Directory.test_dir)
  end

  def test
    setup_dir(Directory.test_dir)
  end

  def previous
    @shoes.set_image(@image.previous)
  end

  def next
    @shoes.set_image(@image.next)
  end

  private

  def setup_dir(dir)
    @dir = (dir =~ /\/$/ ? dir : dir + '/')
    @image = Image.new(@dir)
    self.next
  end

end