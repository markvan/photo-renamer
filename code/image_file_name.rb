class ImageFileName

  attr_reader :short_file_name

  PATTERNS = {
    :LENOVO_PATTERN  => /^IMG_(?<year>\d\d\d\d)
                            (?<month>\d\d)
                            (?<day>\d\d)_
                            (?<hour>\d\d)
                            (?<minute>\d\d)
                            (?<second>\d\d)
                            (?<type>\..*)$/x ,

    :SCREEN_SHOT_PATTERN => /^Screen[ ]Shot[ ](?<year>\d\d\d\d)-
                            (?<month>\d\d)-
                            (?<day>\d\d)[ ]at[ ]
                            (?<hour>\d\d).
                            (?<minute>\d\d).
                            (?<second>\d\d)
                            (?<type>\..*)$/x ,

    :TRANSFORMED_PATTERN => /^(?<year>\d\d\d\d).
                            (?<month>\d\d).
                            (?<day>\d\d)[ _-]+
                            (?<hour>\d\d).
                            (?<minute>\d\d)
                            (?<description>.*)
                            (?<type>\..*)$/x
  }

  def initialize(name)
    name.strip!
    name.sub!(/.*\//, '') if name[0] == '/'
    @short_file_name = name
  end

  def inserted_text
    matches_transformed? ? matches_transformed?[:description].strip : ''
  end

  def potential_new_filename(insert_str)
    m = matches_any?
    if m
      "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}:#{m[:minute]}  #{insert_str}  #{m[:type]}"
    else
      @short_file_name
    end
  end

  def matches_transformed?
    matches?(PATTERNS[:TRANSFORMED_PATTERN])
  end

  def matches_any?
    found = PATTERNS.reject{|name, pattern| ! matches?(pattern) }
    found.count > 0 ? matches?(found.to_a[0][1]) : false
  end

  def matches?(pattern)
    @short_file_name.match(pattern)
  end

end