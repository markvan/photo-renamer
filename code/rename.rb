require 'tk'
require 'tkextlib/tkimg'
require './code/picture_library'
require './code/picture_view'
require './code/image_file_name'

def ppp(*args)
  puts 'x'; true
end

class Layout
  def self.picture_view
    @@picture_view
  end

  def initialize(width, height)
    @viewport=[width, height]
    @root = TkRoot.new
    @root.title = 'Picture Renamer'
    @root.geometry("#{@viewport[0]+20}x#{@viewport[1]+20}")

    @prev_button = TkButton.new(@root) { text 'prev'; command proc { Layout.picture_view.previous_image } }
    @next_button = TkButton.new(@root) { text 'next'; command proc { Layout.picture_view.next_image } }

    entry_width = 70
    label_width = 14
    @original_name_label  = TkLabel.new(@root) { width label_width; text '    Original'; justify 'right'}
    @original_name        = TkEntry.new(@root) { width entry_width }
    @insertion_text_label = TkLabel.new(@root) { width label_width;  text 'Description' }
    @insertion_text       = TkEntry.new(@root) { width entry_width; validate 'key' }
    @new_name_label       = TkLabel.new(@root) { width label_width;   text '    Current' }
    @new_name             = TkEntry.new(@root) { width entry_width }

    @@picture_view = PictureView.new('/Users/mark/Pictures/art', @original_name, @insertion_text, @new_name)
    @insertion_text.validatecommand([proc{|p| Layout.picture_view.new_insert_str(p)},'%P'])

    layout
  end

  def layout
    @prev_button.grid('row' => 0, 'column' => 0, 'sticky' => 'e')
    @next_button.grid('row' => 0, 'column' => 1, 'sticky' => 'w')

    @original_name_label.grid('row' => 1, 'column' => 0, 'sticky' => 'e')
    @original_name.grid('row' => 1, 'column' => 1, 'sticky' => 'w')

    @insertion_text_label.grid('row' => 2, 'column' => 0, 'sticky' => 'e')
    @insertion_text.grid('row' => 2, 'column' => 1, 'sticky' => 'w')

    @new_name_label.grid('row' => 3, 'column' => 0, 'sticky' => 'e')
    @new_name.grid('row' => 3, 'column' => 1, 'sticky' => 'w')

    @@picture_view.tk_lable.grid('row' => 4, 'column' => 0, 'columnspan' => 2, 'pady' => 25)
  end
end

Layout.new(700, 740)

Tk.mainloop


