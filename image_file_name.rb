class ImageFileName

  attr_reader :full_file_name, :directory, :short_file_name
  def initialize(full_name)
    @full_file_name = full_name
    @directory = full_name.sub(/\/[^\/]*$/,'/')
    @short_file_name = full_name.sub(/\/.*\//, '')
  end

  def is_lenovo?
    !! @short_file_name.match(/IMG_(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)\d\d(\..*)/)
  end

  def is_transformed?
    !! @short_file_name.match(/\d\d\d\d\.\d\d\.\d\d__\d\d\.\d\d[\w ]+\..*$/)
  end
end