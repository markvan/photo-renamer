class ImageView

  LENOVO_PATTERN = /^IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)$/

  TRANSFORMED_PATTERN = /^(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)([\w ]+)(\..*)$/

  def initialize(dir, original_name_widget, insertion_text_widget, current_name_widget)
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @image_library = ImageLibrary.new(@dir)
    @original_name = original_name_widget
    @insertion_text = insertion_text_widget
    @current_name = current_name_widget
    @picture_view = TkLabel.new($root)
    set(@image_library.next_image)
    lock_fields
  end

  def set_file_name_using_insert_str(insert_str)
    new_short_fn = potential_new_name(insert_str)
    if new_short_fn
      if @image_library.change_name(new_short_fn)
        @insertion_text.highlightbackground = 'green'
      else
        @insertion_text.highlightbackground = 'red'
      end
    end
    @current_name.state = 'normal'
    @current_name.value = @image_library.short_file_name
    @current_name.state = 'readonly'
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

  def potential_new_name(insert_str)
    file_name = ImageFileName.new(@original_name.value)
    m = file_name.match(LENOVO_PATTERN)
    if m
      potential_new_fn = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[6]}"
    else
      n =file_name.match(TRANSFORMED_PATTERN)
      if n
        potential_new_fn = "#{n[1]}.#{n[2]}.#{n[3]}__#{n[4]}.#{n[5]}  #{insert_str} #{n[7]}"
      else
        potential_new_fn = @original_name.value
      end
    end
    potential_new_fn.strip
  end

  def set(image)
    sample_every  = sampling([600,600], image.width, image.height)
    display_image = TkPhotoImage.new
    display_image.copy(image, subsample: [sample_every])
    @picture_view.image   = display_image
    unlock_fields
    @original_name.value  = @image_library.short_file_name
    @current_name.value       = @original_name.value
    lock_fields
    fn = ImageFileName.new(image.file)
    if fn.matches_any?
      @insertion_text.value = fn.inserted_text
      @insertion_text.background = 'white'
    else
      @insertion_text.value = ''
      @insertion_text.background = 'gray'
    end
    @insertion_text.highlightbackground = 'white'
  end

  def unlock_fields
    @original_name.state = 'normal'
    @current_name.state = 'normal'
  end

  def lock_fields
    @original_name.state = 'readonly'
    @original_name.borderwidth = 0
    @current_name.state = 'readonly'
    @current_name.borderwidth = 0
  end

  def sampling(viewport, im_height, im_width)
    x = im_height.to_f/viewport[0]
    y = im_width.to_f/viewport[1]
    every = [x, y].max
    floor = every.floor
    every.modulo(1) > 0 ? floor + 1 : floor
  end
end