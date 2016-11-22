require 'exifr'
include EXIFR

class ImageFileName

  attr_reader :short_file_name

  require __dir__+'/../patterns.rb'

  def initialize(orig_file_name, curr_file_name = ' ')
    make_matchers
    # to work with Lumix Pddddddd formats 'file' must be a full path to a file below '/*'
    @full_file_name  = orig_file_name.strip
    @short_file_name = File.basename(@full_file_name)
    @curr_file_name = curr_file_name.strip
  end

  def inserted_text
    matches_transformed? ? matches_transformed?[:description].strip : ''
  end

  def reformat_with_space
    match_data = @short_file_name.match(/(?<base_name>.*)(?<type>\.[a-zA-Z]+)$/)
    match_data[:base_name].strip+' '+match_data[:extension]
  end

  def potential_new_filename(new_description)
    m = matches_any?
    t = matches_transformed?
    lu = matches_lumix?
    case true

      # lumix with new description
      when lu && new_description.length > 0
        dt = CheckExif.new(@curr_file_name).date_time.gsub!(/:/, '.')
        "#{dt}  #{new_description}  #{m[:extension]}"

      # lumix without new description
      when lu && new_description.length == 0
        @short_file_name

      # anything (other than lumix) with a new description
      when m && new_description.length > 0
        "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}.#{m[:minute]}  #{new_description}  #{m[:extension]}"

      # anything (other than lumix) with no new description and an old descripotion
      when m && m[:description].length > 0 && new_description.length == 0
        "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}.#{m[:minute]}  #{m[:extension]}"

      # transformed with no new description and no old descripotion
      when t && t[:description].length == 0 && new_description.length == 0
        "#{t[:year]}-#{t[:month]}-#{t[:day]} #{t[:hour]}.#{t[:minute]} #{t[:extension]}"

      # anything (other than lumix and transformed) with no new description and no old descripotion
      when m && new_description.length == 0 && m[:description].length == 0
        @short_file_name

      # anything with an extension
      when match_data = @short_file_name.match(/(?<base_name>.*)(?<type>\.[a-zA-Z]+)$/)
        match_data[:base_name].strip+' '+match_data[:extension]

      # anything without an extension
      else
        @short_file_name
    end
  end

  def matches_transformed?
    (! matches_samsung_ace? && matches?(TRANSFORMED)) || false
  end

  def matches_any_original?
    found = PATTERNS.reject{|name, pattern| ! matches?(pattern) }
    found.count > 0 ? matches?(found.to_a[0][1]) : false
  end

  def matches_any?
    matches_transformed? || matches_any_original?
  end

  private

  def make_matchers
    PATTERNS.each_key do |key|
      name = 'matches_'+key.to_s.downcase+'?'
      define_singleton_method(name.to_sym) do
        matches?(PATTERNS[key]) || false
      end
    end
  end

  def matches?(pattern)
    @short_file_name.match(pattern)
  end

end