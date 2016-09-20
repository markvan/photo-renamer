class Image

  def initialize(dir)
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @files = Dir[@dir+'*'].sort_by(&:downcase)
    @index = -1
  end

  def next
    get_image(:next_image)
  end

  def previous
    get_image(:previous_image)
  end

  def full_file_name
    @files[@index]
  end

  def short_file_name
    @files[@index].sub(/^.*\//, '')
  end

  def inserted_text
    ImageFileName.new(@full_file_name).inserted_text
  end

  def change_name(potential_short_name)
    potential_short_name.strip!
    return false if potential_short_name.empty?
    full_old_name = @files[@index]
    full_new_name = @dir+potential_short_name
    return false if full_old_name == full_new_name || File.exist?(full_new_name)

    File.rename(full_old_name, full_new_name)

    @files[@index] = full_new_name
    # puts "'#{full_old_name}' renamed '#{full_new_name}'"
    true
  end

  private

  def get_image(retriever)
    send(retriever)
    image = TkPhotoImage.new
    if File.directory?(@full_file_name)
      image.file = __dir__ + '/../images/folder.jpg'
    elsif @full_file_name =~ /\.(jpg|JPG|jpeg|JPEG|png|PNG|gif|GIF|tiff|TIFF)$/
      image.file = @full_file_name
    else
      image.file = __dir__ + '/../images/no_renderer.jpg'
    end
    image
  end

  def next_image
    @index == @files.count - 1 ? @index = 0 : @index += 1
    @full_file_name = @files[@index]
  end

  def previous_image
    @index == 0 ? @index = @files.count - 1 : @index -= 1
    @full_file_name = @files[@index]
  end

end