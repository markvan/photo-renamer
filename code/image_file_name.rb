class ImageFileName

  attr_reader :short_file_name

  PATTERNS = {
    :LENOVO_PATTERN  => /^IMG_(?<year>\d\d\d\d)
                            (?<month>\d\d)
                            (?<day>\d\d)_
                            (?<hour>\d\d)
                            (?<minute>\d\d)
                            (?<second>\d\d)
                            (?<description>)
                            (?<type>\..*)$/x ,

    :SCREEN_SHOT_PATTERN => /^Screen[ ]Shot[ ](?<year>\d\d\d\d)-
                            (?<month>\d\d)-
                            (?<day>\d\d)[ ]at[ ]
                            (?<hour>\d\d).
                            (?<minute>\d\d).
                            (?<second>\d\d)
                            (?<description>)
                            (?<type>\..*)$/x
  }

  TRANSFORMED_PATTERN =  /^(?<year>\d\d\d\d)-
                              (?<month>\d\d)-
                              (?<day>\d\d)[ ]
                              (?<hour>\d\d)\.
                              (?<minute>\d\d)[ ]*
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

  def reformat_with_space
    match_data = @short_file_name.match(/(?<base_name>.*)(?<type>\.[a-zA-Z]+)$/)
    match_data[:base_name].strip+' '+match_data[:type]
  end

  def potential_new_filename(insert_str)
    m = matches_any?
    t = matches_transformed?
    case true
      # got a string to insert, make the transformed fn regardless of original fn format
      when m && insert_str.length > 0
        "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}.#{m[:minute]}  #{insert_str}  #{m[:type]}"

      # transformed original fn has a description, want rid of it by making insert field empty
      when m && insert_str.length == 0 && m[:description].length > 0
        "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}.#{m[:minute]}  #{m[:type]}"

      when t && t[:description].length == 0 && insert_str.length == 0
        "#{t[:year]}-#{t[:month]}-#{t[:day]} #{t[:hour]}.#{t[:minute]} #{t[:type]}"


      # original fn of any matched type has NO description, just space the extension away from fn body
      when m && insert_str.length == 0 && m[:description].length == 0
        @short_file_name

      # original fn is not matched, has an extension, just space the extension away
      when match_data = @short_file_name.match(/(?<base_name>.*)(?<type>\.[a-zA-Z]+)$/)
        match_data[:base_name].strip+' '+match_data[:type]

      # original fn does not havve an extension
      else
        @short_file_name
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