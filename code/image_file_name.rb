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
    ret = ''
    m = matches_transformed?
    ret = m[6].strip if m
    ret
  end

  def potential_new_filename(insert_str)
    if m = matches_any?
      "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}:#{m[:minute]}  #{insert_str}  #{m[:type]}"
    else
      @short_file_name
    end
  end

  def matches_transformed?
    match(PATTERNS[:TRANSFORMED_PATTERN])
  end

  def matches_any?
    found = PATTERNS.reject{|name, pattern| ! match(pattern) }
    puts found.count
    found.count > 0 ? match(found.to_a[0][1]) : false
  end

  def match(pattern)
    @short_file_name.match(pattern)
  end

end