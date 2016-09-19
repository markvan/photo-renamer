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
    potential_new_fn = potential_new_filename(insert_str)
    if potential_new_fn
      if @image_library.change_name(potential_new_fn)
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

  def potential_new_filename(insert_str)
    ImageFileName.new(@original_name.value).potential_new_filename(insert_str)
  end

  def set(image)
    @picture_view.image   = sample(image)
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

  def sample(image)
    sample_every  = sampling([600,600], image.width, image.height)
    TkPhotoImage.new.copy(image, subsample: [sample_every])
  end

  def sampling(viewport, im_height, im_width)
    x = im_height.to_f/viewport[0]
    y = im_width.to_f/viewport[1]
    every = [x, y].max
    floor = every.floor
    every.modulo(1) > 0 ? floor + 1 : floor
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

end