require 'fileutils'

base = '/Users/mark/RubymineProjects/photo-renamer/'
require 'tk'
require 'tkextlib/tkimg'
require base+'./code/image'
require base+'./code/image_view'
require base+'./code/image_file_name'

def ppp(*args)
  puts 'x'; truemage libray to image
end

class Layout
  def self.image_view
    @@image_view
  end

  def initialize(width, height)
    @viewport=[width, height]
    @root = TkRoot.new
    @root.title = '/Users/mark/Pictures/art'
    @root.geometry("#{@viewport[0]+20}x#{@viewport[1]+20}")

    @dir_button  = TkButton.new(@root) { text 'dir';  command proc { Layout.choose_dir } }
    @test_button  = TkButton.new(@root) { text 'test';  command proc { Layout.test_dir } }
    @prev_button = TkButton.new(@root) { text 'prev'; command proc { Layout.image_view.previous_image } }
    @next_button = TkButton.new(@root) { text 'next'; command proc { Layout.image_view.next_image } }

    entry_width = 70
    label_width = 14
    @original_name_label  = TkLabel.new(@root) { width label_width; text '    Original'; justify 'right'}
    @@original_name       = TkEntry.new(@root) { width entry_width }
    @insertion_text_label = TkLabel.new(@root) { width label_width;  text 'Description' }
    @@insertion_text      = TkEntry.new(@root) { width entry_width; validate 'key' }
    @current_name_label   = TkLabel.new(@root) { width label_width;   text '    Current' }
    @@current_name        = TkEntry.new(@root) { width entry_width }

    layout
  end

  def layout
    @dir_button.grid('row' => 0, 'column' => 0, 'sticky' => 'w')
    @test_button.grid('row' => 1, 'column' => 0, 'sticky' => 'w')

    @prev_button.grid('row' => 0, 'column' => 1, 'sticky' => 'e')
    @next_button.grid('row' => 0, 'column' => 2, 'sticky' => 'w')

    @original_name_label.grid('row' => 1, 'column' => 1, 'sticky' => 'e')
    @@original_name.grid('row' => 1, 'column' => 2, 'sticky' => 'w')

    @insertion_text_label.grid('row' => 2, 'column' => 1, 'sticky' => 'e')
    @@insertion_text.grid('row' => 2, 'column' => 2, 'sticky' => 'w')

    @current_name_label.grid('row' => 3, 'column' => 1, 'sticky' => 'e')
    @@current_name.grid('row' => 3, 'column' => 2, 'sticky' => 'w')

  end

  def self.choose_dir
    dir = Tk.chooseDirectory
    setup_dir(dir)
  end

  def self.test_dir
    dir = ruby_root + '/spec/image_library'
    from_dir = ruby_root + '/spec/image_setup'
    puts Dir.glob("#{from_dir}/*")
    FileUtils.rm_f( Dir.glob("#{dir}/*") )
    FileUtils.cp( Dir.glob("#{from_dir}/*") , dir)
    setup_dir(dir)
  end

  def self.ruby_root
    __dir__.gsub(/\/code/, '')
  end

  def self.setup_dir(dir)
    @@image_view = ImageView.new(dir, @@original_name, @@insertion_text, @@current_name)
    @@insertion_text.validatecommand([proc{|p| Layout.image_view.set_file_name_using_insert_str(p)}, '%P'])
    @@image_view.tk_lable.grid('row' => 4, 'column' => 0, 'columnspan' => 3, 'pady' => 25)
  end
end

Layout.new(700, 740)

Tk.mainloop


