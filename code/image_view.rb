class ImageView

  LENOVO_PATTERN = /^IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)$/

  TRANSFORMED_PATTERN = /^(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)([\w ]+)(\..*)$/

  def initialize(dir, original_name, insertion_text, new_name)
    dir =~ /\/$/ ? @dir = dir : @dir = dir + '/'
    @original_name = original_name
    @insertion_text = insertion_text
    @new_name = new_name
    @picture_view = TkLabel.new($root)
    @image_library = ImageLibrary.new(dir)
    set(@image_library.next_image)
  end

  def set_file_name_using_insert_str(insert_str)
    new_short_name = new_name(insert_str)
    if new_short_name != @original_name.value
      if @image_library.change_name(new_short_name)
        @insertion_text.highlightbackground = 'green'
      else
        @insertion_text.highlightbackground = 'red'
      end
    end
  end

  def next_image
    set(@image_library.next_image)
  end

  def previous_image
    set(@image_library.previous_image)
  end

  def tk_lable
    @picture_view
  end

  private

  def new_name(insert_str)
    file_name = ImageFileName.new(@original_name.value)
    m = file_name.match(LENOVO_PATTERN)
    if m
      @new_name.value = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[6]}"
    else
      n =file_name.match(TRANSFORMED_PATTERN)
      if n
        @new_name.value = "#{n[1]}.#{n[2]}.#{n[3]}__#{n[4]}.#{n[5]}  #{insert_str} #{n[7]}"
      else
        @new_name.value = @original_name.value
      end
    end
    puts "ImageView#new_name sets @new_name.value:#{@new_name.value}"
    @new_name.value.strip
  end

  def set(image)
    sample_every  = sampling([600,600], image.width, image.height)
    display_image = TkPhotoImage.new
    display_image.copy(image, subsample: [sample_every])
    @picture_view.image   = display_image
    @original_name.value  = @image_library.short_file_name
    @new_name.value       = @original_name.value
    fn = ImageFileName.new(image.file)
    @insertion_text.value = fn.inserted_text
    puts ">>> ImageView#set sets @insertion_text.value:#{@insertion_text.value}"

  end

  def sampling(viewport, im_height, im_width)
    x = im_height.to_f/viewport[0]
    y = im_width.to_f/viewport[1]
    every = [x, y].max
    floor = every.floor
    every.modulo(1) > 0 ? floor + 1 : floor
  end
end