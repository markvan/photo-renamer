class ImageFileName

  attr_reader :short_file_name

  LENOVO_PATTERN  = /^IMG_(?<year>\d\d\d\d)
                          (?<month>\d\d)
                          (?<day>\d\d)_
                          (?<hour>\d\d)
                          (?<minute>\d\d)
                          (?<second>\d\d)
                          (?<type>\..*)$/x

  TRANSFORMED_PATTERN = /^(?<year>\d\d\d\d)\.
                          (?<month>\d\d)\.
                          (?<day>\d\d)__
                          (?<hour>\d\d)\.
                          (?<minute>\d\d)
                          (?<description>.*)
                          (?<type>\..*)$/x

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
    if m = matches_any?
      potential_new_fn = "#{m[:year]}.#{m[:month]}.#{m[:day]}__#{m[:hour]}.#{m[:minute]}  #{insert_str} #{m[:type]}"
    else
      potential_new_fn = @short_file_name
    end
    potential_new_fn
  end
end