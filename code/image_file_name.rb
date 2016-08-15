class ImageFileName

  attr_reader :full_file_name, :directory, :short_file_name

  LENOVO_PATTERN = /^IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)$/

  TRANSFORMED_PATTERN = /^(\d\d\d\d)\.(\d\d)\.(\d\d)__(\d\d)\.(\d\d)([\w ]+)(\..*)$/

  def initialize(full_name)
    @full_file_name = full_name
    @directory = full_name.sub(/\/[^\/]*$/, '/')
    @short_file_name = full_name.sub(/\/.*\//, '')
  end

  def inserted_text
    ret = ''
    m = matches_transformed?
    ret = m[6].strip if m
    ret
  end

  private

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
end