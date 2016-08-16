class ImageLibrary

  def initialize(dir)
    @dir = dir
    @dir += '/' unless @dir =~ /\/$/
    @index = -1
    @files = Dir[@dir+'*'].sort_by(&:downcase)
    true
  end

  def next_image
    get_image(:next)
  end

  def previous_image
    get_image(:previous)
  end

  def full_file_name
    @full_file_name
  end

  def short_file_name
    @full_file_name.sub(/^.*\//, '')
  end

  def inserted_text
    puts 'ImageLibrary#inserted_text'
    file_name = ImageFileName.new(@full_file_name)
    file_name.inserted_text
  end

  def change_name(new_name)
    full_old_name = @files[@index]
    full_new_name = @dir+new_name
    return false if File.exist?(full_new_name) || full_old_name == full_new_name
    File.rename(full_old_name, full_new_name)
    @files[@index] = full_new_name
    puts "'#{full_old_name}' renamed '#{full_new_name}'"
    true
  end

  private

  def get_image(retriever)
    @full_file_name = send(retriever)
    image = TkPhotoImage.new
    if File.directory?(@full_file_name)
      image.file = Dir.pwd+'/images/folder.jpg'
    elsif @full_file_name =~ /\.(jpg|JPG|jpeg|JPEG|png|PNG|gif|GIF|tiff|TIFF)$/
      image.file = @full_file_name
    else
      image.file = Dir.pwd+'/images/no_renderer.jpg'
    end
    image
  end

  def next
    @index == @files.count - 1 ? @index = 0 : @index += 1
    @full_file_name = @files[@index]
  end

  def previous
    @index == 0 ? @index = @files.count - 1 : @index -= 1
    @full_file_name = @files[@index]
  end

end