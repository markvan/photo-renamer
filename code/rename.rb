require 'fileutils'

def ruby_root
  __dir__.gsub(/\/code/, '')
end

require 'tk'
require 'tkextlib/tkimg'
require ruby_root+'/code/image'
require ruby_root+'/code/view'
require ruby_root+'/code/image_file_name'
require ruby_root+'/code/check_exif'

class Layout

  def initialize(width, height)
    setup_root(width, height)
    layout
  end

  def choose_dir
    dir = Tk.chooseDirectory
    setup_dir(dir)
  end

  def test_dir
    from_dir = ruby_root + '/spec/image_setup'
    to_dir = ruby_root + '/spec/image_library'
    FileUtils.rm_f( Dir.glob("#{to_dir}/*") )
    FileUtils.cp( Dir.glob("#{from_dir}/*"), to_dir )
    setup_dir(to_dir)
  end

  def image_view
    @image_view
  end

  private

  def self.instance
    ObjectSpace.each_object(Layout).first
  end

  def setup_root(width, height)
    @root = TkRoot.new
    @root.geometry("#{width+20}x#{height+20}")
    @root.title = 'haz renamz'
  end

  def layout
    entry_width = 70
    label_width = 14
    grid_cell( TkButton.new(@root) { text 'dir';  command proc { Layout.instance.choose_dir } },                0, 0, 'w')
    grid_cell( TkButton.new(@root) { text 'prev'; command proc { Layout.instance.image_view.previous_image } }, 0, 1, 'e')
    grid_cell( TkButton.new(@root) { text 'next'; command proc { Layout.instance.image_view.next_image } },     0, 2, 'w')

    grid_cell( TkButton.new(@root) { text 'test'; command proc { Layout.instance.test_dir } },   1, 0, 'w')
    grid_cell( TkLabel.new(@root)  { width label_width; text '    Original'; justify 'right'},   1, 1, 'e')
    @original_name       = grid_cell( TkEntry.new(@root) { width entry_width },                  1, 2, 'w')

    grid_cell( TkLabel.new(@root)  { width label_width; text ' Date time' },                     2, 1, 'e')
    @date_time_text      = grid_cell( TkEntry.new(@root) { width entry_width  },                 2, 2, 'w')

    grid_cell( TkLabel.new(@root)  { width label_width; text 'Description' },                     3, 1, 'e')
    @insertion_text      = grid_cell( TkEntry.new(@root) { width entry_width; validate 'key' },   3, 2, 'w')

    grid_cell( TkLabel.new(@root)  { width label_width; text '    Current' },                     4, 1, 'e')
    @current_name        = grid_cell( TkEntry.new(@root) { width entry_width },                   4, 2, 'w')
  end

  def grid_cell(tk_widget, row, column, sticky)
    tk_widget.grid('row' => row, 'column' => column,'sticky' => sticky)
    tk_widget
  end

  def setup_dir(dir)
    @image_view = View.new(dir, @original_name, @date_time_text, @insertion_text, @current_name)
    @insertion_text.validatecommand([proc{|p| image_view.validate_insert(p)}, '%P'])
    @image_view.tk_lable.grid('row' => 5, 'column' => 0, 'columnspan' => 3, 'pady' => 25)
  end

end

Layout.new(700, 740)

Tk.mainloop


