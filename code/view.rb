class View

  def initialize(dir, original_name_widget, insertion_text_widget, current_name_widget)
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @image_library = Image.new(@dir)
    @original_name = original_name_widget
    @insertion_text = insertion_text_widget
    @current_name = current_name_widget
    @picture_view = TkLabel.new($root)
    set_image_and_text(@image_library.next_image)
    lock_fields
  end

  def set_file_name_using_insert_str(insert_str)
    potential_new_fn = potential_new_filename(insert_str.strip) #todo fix trailing spaces ui
    if potential_new_fn
      if @image_library.change_name(potential_new_fn)
        @insertion_text.highlightbackground = 'green'
        @current_name.state = 'normal'
        @current_name.value = @image_library.short_file_name
        @current_name.state = 'readonly'
      else
        @insertion_text.highlightbackground = 'red'
      end
    end

  end

  def next_image
    set_image_and_text(@image_library.next_image)
  end

  def previous_image
    set_image_and_text(@image_library.previous_image)
  end

  def tk_lable
    @picture_view
  end

  private

  def potential_new_filename(insert_str)
    ImageFileName.new(@original_name.value).potential_new_filename(insert_str)
  end

  def set_image_and_text(image)
    @picture_view.image  = sample(image)
    unlock_fields
    @original_name.value = @image_library.short_file_name
    @current_name.value  = @original_name.value
    lock_fields
    original_fn = ImageFileName.new(image.file)
    if original_fn.matches_any?
      @insertion_text.value = original_fn.inserted_text
      @insertion_text.background = 'white'
    else
      @insertion_text.value = ''
      @insertion_text.background = 'gray'
    end
=begin
    if @image_library.matches_any?
      @insertion_text.value = @image_library.inserted_text
    else
      @insertion_text.value = ''
      @insertion_text.background = 'gray'
    end
=end
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