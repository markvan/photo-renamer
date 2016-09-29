class Directory
  def test_dir
    from_dir = ruby_root + '/spec/image_setup'
    to_dir = ruby_root + '/spec/image_library'
    FileUtils.rm_f( Dir.glob("#{to_dir}/*") )
    FileUtils.cp( Dir.glob("#{from_dir}/*"), to_dir )
    to_dir
  end

  def choose_dir

  end

  def ruby_root
    __dir__.gsub(/\/code/,'')
  end
end