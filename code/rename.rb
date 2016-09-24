require 'fileutils'

def ruby_root
  __dir__.gsub(/\/code/, '')
end

require 'tk'
require 'tkextlib/tkimg'
require ruby_root+'/code/image'
require ruby_root+'/code/view'
require ruby_root+'/code/image_file_name'

class Layout

  def initialize(width, height)
    setup_root(width, height)
    layout_buttons
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

  def view
    @view
  end

  private

  def self.instance
    ObjectSpace.each_object(Layout).first
  end

  def setup_root(width, height)
    @root = TkRoot.new
    @root.geometry("#{width+20}x#{height+20}")
    @root.title = 'haz renamez'
  end

  def layout_buttons
    grid_cell( TkButton.new(@root) { text 'dir';  command proc { Layout.instance.choose_dir } },          0, 0, 'w')
    grid_cell( TkButton.new(@root) { text 'prev'; command proc { Layout.instance.view.previous_image } }, 0, 1, 'e')
    grid_cell( TkButton.new(@root) { text 'next'; command proc { Layout.instance.view.next_image } },     0, 2, 'w')
    grid_cell( TkButton.new(@root) { text 'test'; command proc { Layout.instance.test_dir } },            1, 0, 'w')
  end

  def grid_cell(tk_widget, row, column, sticky)
    tk_widget.grid('row' => row, 'column' => column,'sticky' => sticky)
    tk_widget
  end

  def setup_dir(dir)
    @view = View.new(dir, @root)
  end

end

Layout.new(700, 740)

Tk.mainloop


