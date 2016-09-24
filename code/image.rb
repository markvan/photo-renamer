class Image

  def initialize(dir)
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @files = Dir[@dir+'*'].sort_by(&:downcase)
    @index = -1
  end

  def next
    get_image_to_show(:next_image)
  end

  def previous
    get_image_to_show(:previous_image)
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
    full_potential_name = @dir + potential_short_name
    return false if full_potential_name == full_old_name || File.exist?(full_potential_name)
    File.rename(full_old_name, full_potential_name)
    @files[@index] = full_potential_name
    true
  end

  private

  def get_image_to_show(retriever)
    send(retriever)
    image = TkPhotoImage.new
    case true
      when File.directory?(@full_file_name)
        image.file = ruby_root + '/images/folder.jpg'
      when !!@full_file_name.match(/\.(jpg|JPG|jpeg|JPEG|png|PNG|gif|GIF|tiff|TIFF)$/)
        image.file = @full_file_name
      else
        image.file = ruby_root + '/images/no_renderer.jpg'
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