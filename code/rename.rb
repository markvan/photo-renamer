require 'fileutils'

base = '/Users/mark/RubymineProjects/photo-renamer/'
require 'tk'
require 'tkextlib/tkimg'
require base+'./code/image'
require base+'./code/view'
require base+'./code/image_file_name'

class Layout
  def self.image_view
    @@image_view
  end

  def initialize(width, height)
    setup_root(width, height)
    layout
  end

  def setup_root(width, height)
    @root = TkRoot.new
    @root.geometry("#{width+20}x#{height+20}")
    @root.title = 'haz renamez'
  end

  def layout
    entry_width = 70
    label_width = 14
    grid_cell( TkButton.new(@root) { text 'dir';  command proc { Layout.choose_dir } },                0, 0, 'w')
    grid_cell( TkButton.new(@root) { text 'test'; command proc { Layout.test_dir } },                  1, 0, 'w')
    grid_cell( TkButton.new(@root) { text 'prev'; command proc { Layout.image_view.previous_image } }, 0, 1, 'e')
    grid_cell( TkButton.new(@root) { text 'next'; command proc { Layout.image_view.next_image } },     0, 2, 'w')

    grid_cell( TkLabel.new(@root)  { width label_width; text '    Original'; justify 'right'},         1, 1, 'e')
    grid_cell( TkLabel.new(@root)  { width label_width; text 'Description' },                          2, 1, 'e')
    grid_cell( TkLabel.new(@root)  { width label_width; text '    Current' },                          3, 1, 'e')

    @@original_name       = grid_cell( TkEntry.new(@root) { width entry_width },                       1, 2, 'w')
    @@insertion_text      = grid_cell( TkEntry.new(@root) { width entry_width; validate 'key' },       2, 2, 'w')
    @@current_name        = grid_cell( TkEntry.new(@root) { width entry_width },                       3, 2, 'w')
  end

  def grid_cell(tk_widget, row, column, sticky)
    tk_widget.grid('row' => row, 'column' => column,'sticky' => sticky)
    tk_widget
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
    @@image_view = View.new(dir, @@original_name, @@insertion_text, @@current_name)
    @@insertion_text.validatecommand([proc{|p| Layout.image_view.set_file_name_using_insert_str(p)}, '%P'])
    @@image_view.tk_lable.grid('row' => 4, 'column' => 0, 'columnspan' => 3, 'pady' => 25)
  end
end

Layout.new(700, 740)

Tk.mainloop


