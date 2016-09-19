class ImageFileName

  attr_reader :short_file_name

  LENOVO_PATTERN = /^IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)$/

  TRANSFORMED_PATTERN = /^(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)(.*)(\..*)$/

  def initialize(name)
    name.strip!
    name.sub!(/^\/.*\//, '') if (name =~ /^\//) == 0
    @short_file_name = name
  end

  def inserted_text
    ret = ''
    m = matches_transformed?
    ret = m[6].strip if m
    ret
  end

  def match(pattern)
    @short_file_name.match(pattern)
  end

  def matches_lenovo?
    return false if match(TRANSFORMED_PATTERN)
    match(LENOVO_PATTERN)
  end

  def matches_transformed?
    return false if match(LENOVO_PATTERN)
    match(TRANSFORMED_PATTERN)
  end

  def matches_any?
    matches_lenovo? || matches_transformed?
  end

  def matches_none?
    ! matches_any?
  end

  def potential_new_filename(insert_str)
    if m = matches_lenovo?
      potential_new_fn = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[6]}"
    elsif m = matches_transformed?
      potential_new_fn = "#{m[1]}.#{m[2]}.#{m[3]}__#{m[4]}.#{m[5]}  #{insert_str} #{m[7]}"
    else
      potential_new_fn = @short_file_name
    end
    potential_new_fn
  end
end