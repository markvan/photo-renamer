class View

  def initialize(dir, root)
    entry_width = 70
    label_width = 14
    grid_cell( TkLabel.new(root)  { width label_width; text '    Original'; justify 'right'}, 1, 1, 'e')
    grid_cell( TkLabel.new(root)  { width label_width; text 'Description' },                  2, 1, 'e')
    grid_cell( TkLabel.new(root)  { width label_width; text '    Current' },                  3, 1, 'e')
    @dir = ( dir =~ /\/$/  ?  dir : dir + '/' )
    @image = Image.new(@dir)
    @original_filename = grid_cell( TkEntry.new(root) { width entry_width },                       1, 2, 'w')
    @insertion_text    = grid_cell( TkEntry.new(root) { width entry_width; validate 'key' },       2, 2, 'w')
    @insertion_text.validatecommand([proc{|p| validate_inserted_text(p)}, '%P'])
    @current_filename  = grid_cell( TkEntry.new(root) { width entry_width },                       3, 2, 'w')
    @image_view        = TkLabel.new(root)
    @image_view.grid('row' => 4, 'column' => 0, 'columnspan' => 3, 'pady' => 25)
    set_image_with_first_text(@image.next)
  end

  def grid_cell(tk_widget, row, column, sticky)
    tk_widget.grid('row' => row, 'column' => column,'sticky' => sticky)
    tk_widget
  end

  def xxx(insert_str)
    if insert_str == ''
      potential_new_fn = @original_filename.value
    else
      matches = ImageFileName.new(@original_filename.value)
      if matches
        potential_new_fn = potential_new_filename(insert_str.strip) #todo fix trailing spaces ui
      else
        potential_new_fn = insert_str+' '+matches[:type]
      end
    end

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


  def validate_inserted_text(insert_str)

  end

  def next_image
    set_image_with_first_text(@image.next)
  end

  def previous_image
    set_image_with_first_text(@image.previous)
  end

  private

  def potential_new_filename(insert_str)
    ImageFileName.new(@original_filename.value).potential_new_filename(insert_str)
  end

  def set_image_with_first_text(image)
    unlock_fields
    @image_view.image  = sample(image)
    @original_filename.value = @image.short_file_name
    @current_filename.value  = @original_filename.value
    filename = ImageFileName.new(image.file)
    # setting the insertion text causes validation
    @insertion_text.value     = ''
    @insertion_text.background = 'red'
    @insertion_text.value     = filename.new_inserted_text
    @insertion_text.value     = 'shite'


    #@insertion_text.highlightbackground = 'white'
    lock_fields
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
    @original_filename.state = 'normal'
    @current_filename.state = 'normal'
    @insertion_textstate = 'normal'
  end

  def lock_fields
    @original_filename.state = 'readonly'
    @original_filename.borderwidth = 0
    @current_filename.state = 'readonly'
    @current_filename.borderwidth = 0
  end

end