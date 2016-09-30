require 'fastimage'

class Image

  def initialize(dir)
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @files = Dir[@dir+'*'].sort_by(&:downcase)
    @orig_files = Dir[@dir+'*'].sort_by(&:downcase)
    @index = -1
  end

  def next
    get_image_to_show(:next_image)
  end

  def previous
    get_image_to_show(:previous_image)
  end

  def size
    puts FastImage.size(@full_file_name)
    FastImage.size(@full_file_name)
  end

  def scale_factor(dim)
    dim = dim.to_f
    sz = size
    puts sz
    x = sz[0].to_f
    y = sz[1].to_f
    x_scale = dim/x
    y_scale = dim/y
    case true
      when x_scale >= 1.0 && y_scale >= 1.0
        scale = 1.0
      when x_scale < 1.0 && y_scale < 1.0
        scale = [x_scale, y_scale].min
      when x_scale >= 1.0
        scale = y_scale
      else
        scale = x_scale
    end
    puts
    puts short_file_name
    puts "  #{dim}: x #{x} x scale #{x_scale} y #{y} y scale #{y_scale} chosen scale #{scale}"
    puts  "     calc x #{x*scale} calc y #{y*scale}"
    scale
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

  def unchanged_file_name
    @orig_files[@index]
  end

  def get_image_to_show(retriever)
    send(retriever)
    case true
      when File.directory?(@full_file_name)
        ruby_root + '/images/folder.jpg'
      when !!@full_file_name.match(/\.(jpg|JPG|jpeg|JPEG|png|PNG|gif|GIF|tiff|TIFF)$/)
        @full_file_name
      else
        ruby_root + '/images/no_renderer.jpg'
    end
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