class PictureLibrary

  def initialize(dir)
    @dir = dir
    @dir += '/' unless @dir =~ /\/$/
    @index = -1
    @files = Dir[@dir+'*']
    true
  end

  def next_image
    get_image(:next)
  end

  def previous_image
    get_image(:previous)
  end

  def file_name
    @file_name
  end

  def change_name(new_name)
    full_old_name = @files[@index]
    full_new_name = @dir+new_name
    if full_old_name != full_new_name
      File.rename(full_old_name, full_new_name)
      @files[@index] = full_new_name
      puts "'#{full_old_name}' changed to '#{new_name}'"
    end
  end

  private

  def get_image(retriever)
    image = TkPhotoImage.new
    next_file_name = send(retriever)
    if next_file_name =~ /.[jpg|JPG|jpeg|JPEG|png|PNG|gif|GIF|tiff|TIFF]$/
      image.file = next_file_name
    else
      image.file = './picture.jpg'
    end
    image
  end

  def next
    @index == @files.count - 1 ? @index = 0 : @index += 1
    @file_name = @files[@index]
  end


  def previous
    @index == 0 ? @files.count - 1 : @index -= 1
    @file_name = @files[@index]
  end



end