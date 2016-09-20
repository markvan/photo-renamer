class View

  def initialize(dir, original_name_widget, insertion_text_widget, current_name_widget)
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @image = Image.new(@dir)
    @original_fn = original_name_widget
    @insertion_text = insertion_text_widget
    @current_fn = current_name_widget
    @image_view = TkLabel.new($root)
    set_image_and_text(@image.next)
    lock_fields
  end

  def set_file_name_using_insert_str(insert_str)
    potential_new_fn = potential_new_filename(insert_str.strip) #todo fix trailing spaces ui
    if potential_new_fn
      if @image.change_name(potential_new_fn)
        @insertion_text.highlightbackground = 'green'
        @current_fn.state = 'normal'
        @current_fn.value = @image.short_file_name
        @current_fn.state = 'readonly'
      else
        @insertion_text.highlightbackground = 'red'
      end
    end

  end

  def next_image
    set_image_and_text(@image.next)
  end

  def previous_image
    set_image_and_text(@image.previous)
  end

  def tk_lable
    @image_view
  end

  private

  def potential_new_filename(insert_str)
    ImageFileName.new(@original_fn.value).potential_new_filename(insert_str)
  end

  def set_image_and_text(image)
    @image_view.image  = sample(image)
    unlock_fields
    @original_fn.value = @image.short_file_name
    @current_fn.value  = @original_fn.value
    lock_fields
    original_fn = ImageFileName.new(image.file)
    if original_fn.matches_any?
      @insertion_text.value = original_fn.inserted_text
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
    @original_fn.state = 'normal'
    @current_fn.state = 'normal'
  end

  def lock_fields
    @original_fn.state = 'readonly'
    @original_fn.borderwidth = 0
    @current_fn.state = 'readonly'
    @current_fn.borderwidth = 0
  end

end