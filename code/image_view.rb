class ImageView

  LENOVO_PATTERN = /^IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)$/

  TRANSFORMED_PATTERN = /^(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)([\w ]+)(\..*)$/

  def initialize(dir, original_name, insertion_text, new_name)
    dir =~ /\/$/ ? @dir = dir : @dir = dir + '/'
    @original_name = original_name
    @insertion_text = insertion_text
    @new_name = new_name
    @picture_view = TkLabel.new($root)
    @picture_library = ImageLibrary.new(dir)
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
    file_name = ImageFileName.new(@original_name.value)
    m = file_name.match(LENOVO_PATTERN)
    if m
      @new_name.value = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[6]}"
    else
      n =file_name.match(TRANSFORMED_PATTERN)
      if n
        new_insert_str(insert_str)
        @new_name.value = "#{n[1]}.#{n[2]}.#{n[3]}__#{n[4]}.#{n[5]}  #{insert_str} #{n[6]}"
      else
        @new_name.value = @original_name.value
      end
    end
    @new_name.value
  end

  def set(image)
    sample_every  = sampling([600,600], image.width, image.height)
    display_image = TkPhotoImage.new
    display_image.copy(image, subsample: [sample_every])
    @picture_view.image   = display_image
    @original_name.value  = @picture_library.short_file_name
    @new_name.value       = @original_name.value
    @insertion_text.value = @picture_library.inserted_text
  end

  def sampling(viewport, im_height, im_width)
    x = im_height.to_f/viewport[0]
    y = im_width.to_f/viewport[1]
    every = [x, y].max
    floor = every.floor
    every.modulo(1) > 0 ? floor + 1 : floor
  end
end