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
                            (?<type>\..*)$/x
  }

  TRANSFORMED_PATTERN =  /^(?<year>\d\d\d\d).
                              (?<month>\d\d).
                              (?<day>\d\d)[ ]+
                              (?<hour>\d\d).
                              (?<minute>\d\d)[ ]+
                              (?<description>.*)[ ]*
                              (?<type>\..*)$/x

  def initialize(name)
    name.strip!
    @short_file_name = name
    name.sub!(/.*\//, '') if name[0] == '/'
  end

  def inserted_text
    matches_transformed? ? matches_transformed?[:description].strip : ''
  end

  def potential_new_filename(insert_str)
    m = matches_any?
    case true
      when m && insert_str.length > 0
        "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}.#{m[:minute]}  #{insert_str}  #{m[:type]}"
      when m && insert_str.length == 0
        @short_file_name
      else
        match_data = @short_file_name.match(/(?<base_name>.*)(?<type>\.[a-zA-Z]+)$/)
        match_data[:base_name].strip+' '+match_data[:type]
    end
  end

  def matches_transformed?
    matches?(TRANSFORMED_PATTERN) || false
  end

  def matches_any_original?
    found = PATTERNS.reject{|name, pattern| ! matches?(pattern) }
    found.count > 0 ? matches?(found.to_a[0][1]) : false
  end

  def matches_lenovo?
    matches?(PATTERNS[:LENOVO_PATTERN]) || false
  end

  def matches_screenshot?
    matches?(PATTERNS[:SCREEN_SHOT_PATTERN]) || false
  end

  def matches_any?
    matches_transformed? || matches_any_original?
  end

  def matches?(pattern)
    @short_file_name.match(pattern)
  end

end