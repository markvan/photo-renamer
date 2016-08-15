class PictureView
  def initialize(dir, original_name, insertion_text, new_name)
    @picture_library = PictureLibrary.new(dir)
    @old_name = original_name
    @insertion_text = insertion_text
    @new_name = new_name
    @picture_view = TkLabel.new($root)
    set(@picture_library.next_image)
  end

  def new_insert_str(insert_str)
    @picture_library.change_name(new_name(insert_str))
    true
  end

  def next_image
    set(@picture_library.next_image)
  end

  def previous_image
    set(@picture_library.previous_image)
  end

  def tk_lable
    @picture_view
  end

  private

  def new_name(insert_str)
    m = @old_name.value.match(/IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)/)
    if m
      @new_name.value = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[6]}"
    else
      n = @old_name.value.match(/(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)  [\w ]+  (\..*)/)
      @new_name.value = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[6]}"
    end
    @new_name.value
  end

  def set(image)
    sample_every = sampling([600,600], image.width, image.height)
    display_image = TkPhotoImage.new
    display_image.copy(image, subsample: [sample_every])
    @picture_view.image = display_image
    @old_name.value = @picture_library.file_name.sub(/.*\//,'')
    @new_name.value = new_name('')
  end

  def set_insertion_text
    @insertion_text.value = ''

  end

  def sampling(viewport, im_height, im_width)
    x = im_height.to_f/viewport[0]
    y = im_width.to_f/viewport[1]
    every = [x, y].max
    floor = every.floor
    every.modulo(1) > 0 ? floor + 1 : floor
  end
end