class ImageFileName

  attr_reader :short_file_name

  LENOVO_PATTERN = /^IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)$/

  TRANSFORMED_PATTERN = /^(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)([\w ]+)(\..*)$/

  def initialize(name)
    puts name
    @short_file_name = name
    @short_file_name = name.sub(/^\/.*\//, '') if (name =~ /^\//) == 0
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

  private

  def matches_lenovo?
    return false if match(TRANSFORMED_PATTERN)
    match(LENOVO_PATTERN)
  end

  def matches_transformed?
    return false if match(LENOVO_PATTERN)
    match(TRANSFORMED_PATTERN)
  end
end