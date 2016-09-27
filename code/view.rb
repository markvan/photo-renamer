class View

  def initialize(dir, original_name_widget, insertion_text_widget, current_name_widget)
    @dir = (dir =~ /\/$/ ? dir : dir + '/')
    @image = Image.new(@dir)
    @original_filename = original_name_widget
    @insertion_text = insertion_text_widget
    @current_filename = current_name_widget
    @image_view = TkLabel.new($root)
    Dir.glob(@dir+'*').each do |full_file_name|
      puts "#{File.basename(full_file_name)}   ***  #{CheckExif.new(full_file_name).date_time_msg}"
      set_image_and_text(@image.next)
    end
    set_image_and_text(@image.next)
  end

  def validate_insert(insert_str)
    #  puts "validate_insert #{@original_filename.value} using #{insert_str}"
    potential_new_fn = potential_new_filename(insert_str.strip)
    if potential_new_fn
      if @image.change_name(potential_new_fn)
        @insertion_text.highlightbackground = 'green'
        @current_filename.state = 'normal'
        @current_filename.value = @image.short_file_name
        @current_filename.state = 'readonly'
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
    ImageFileName.new(@dir+@original_filename.value).potential_new_filename(insert_str)
  end

  def set_image_and_text(image)
    @image_view.image = sample(image)
    unlock_fields
    @original_filename.value = @image.short_file_name
    @current_filename.value = @original_filename.value
    lock_fields
    filename = ImageFileName.new(image.file) # This use of ImageFileName without full fn is OK
    if filename.matches_any?
      @insertion_text.value = filename.inserted_text
      @insertion_text.background = 'white'
    else
      @insertion_text.value = ''
      @insertion_text.background = 'gray'
    end
    @insertion_text.highlightbackground = 'white'
    lock_fields
  end

  def sample(image)
    sample_every = sampling([600, 600], image.width, image.height)
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
    @original_filename.state = 'normal'
    @current_filename.state = 'normal'
    @insertion_text.state = 'normal'
  end

  def lock_fields
    @original_filename.state = 'readonly'
    @original_filename.borderwidth = 0
    @current_filename.state = 'readonly'
    @current_filename.borderwidth = 0
  end

end