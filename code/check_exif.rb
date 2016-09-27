require 'delegate'

class CheckExif

  def initialize(full_file_name)
    @file  = full_file_name
    @valid = File.open(full_file_name, 'rb') { |io| val?(io) }
    @exif  = EXIFR::JPEG.new(full_file_name) if @valid
  end

  def date_time_msg
    if @valid
      msg = get_date_time
      msg.nil? ? 'No date and time' : msg
    else
    'No EXIF to get date adn time'
    end
  end

  def date_time
    if @valid
      get_date_time
    else
      false
    end
  end

  private

  def get_date_time
    msg = @exif.date_time_original.to_s
    msg != nil && !msg.empty? ? msg.strip.gsub(/ [+-]\d\d\d\d$/, '') : nil
  end

  def val?(io)
    io = Reader.new(io)
    io.readbyte == 0xFF && io.readbyte == 0xD8
  end

  class Reader < SimpleDelegator
    def readbyte;
      readchar;
    end unless File.method_defined?(:readbyte)

    def readint;
      (readbyte << 8) + readbyte;
    end

    def readframe;
      read(readint - 2);
    end

    def readsof;
      [readint, readbyte, readint, readint, readbyte];
    end

    def next
      c = readbyte while c != 0xFF
      c = readbyte while c == 0xFF
      c
    end
  end

end


