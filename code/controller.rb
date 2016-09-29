class Controller
  def slf=(obj)
    @shoes=obj
  end

  def dir
    @shoes.alert('from dispacher smoochie')
  end

  def test
    from_dir = ruby_root + '/spec/image_setup'
    to_dir = ruby_root + '/spec/image_library'
    FileUtils.rm_f( Dir.glob("#{to_dir}/*") )
    FileUtils.cp( Dir.glob("#{from_dir}/*"), to_dir )
    setup_dir(to_dir)
    @shoes.image = @shoes.image ('https://www.gravatar.com/avatar/b6c235569392cb2f5cfcc8ec61fc8819')
  end

  def setup_dir(dir)
    @dir = (dir =~ /\/$/ ? dir : dir + '/')
    @image = @shoes.image(Image.new(@dir))
  end

  def prev
    @image.next
  end

  def next
    @image.next
  end

end