require 'tk'
require 'tkextlib/tkimg'
require './picture_library'
require './picture_view'

def ppp(*args)
  puts 'x'; true
end

class Layout

  def initialize(width, height)
    @viewport=[width, height]
    @root = TkRoot.new
    @root.title = 'Picture Renamer'
    @root.geometry("#{@viewport[0]+20}x#{@viewport[1]+120}")

    width = 70
    @original_name = TkEntry.new(@root) { width width }
    @insertion_text = TkEntry.new(@root) {
      width width
      validate 'key'
    }
    @new_name = TkEntry.new(@root) { width width }

    @@image_viewer = PictureView.new('/Users/mark/Pictures/art', @original_name, @insertion_text, @new_name)

    @button = TkButton.new(@root) {
      text 'next'
      command proc { Layout.image_viewer.next_image }
    }

    @insertion_text.validatecommand([proc{|p| Layout.image_viewer.new_insert_str(p)},'%P'])

    layout
  end

  def self.image_viewer
    @@image_viewer
  end

  def layout
    @button.grid('row' => 0, 'column' => 0, 'sticky' => 'w')
    @original_name.grid('row' => 1, 'column' => 0, 'sticky' => 'w')
    @insertion_text.grid('row' => 2, 'column' => 0, 'sticky' => 'w')
    @new_name.grid('row' => 3, 'column' => 0, 'sticky' => 'w')
    @@image_viewer.tk_lable.grid('row' => 4, 'column' => 0)
  end
end

Layout.new(600, 600)

Tk.mainloop


