
$col_0 = '15%'
$col_1 = '25%'
$col_2 = '60%'

require __dir__+'/requires'

Shoes.app(title: "Haz Renamz",
           width: 800, height: 800, scroll: true) do

  def get_image
    @image
  end

  def set_image(img)
    puts
    puts "Shoes.app#set_image scale  #{@scale}"
    if @scale != 1.0
      puts '  scale up'
      #@image.scale(1/@scale, 1/@scale)
    end


    image = @controller.image
    #puts image.scale_factor(500)
    #puts "Shoes.app#set_image scale  new #{@scale}"

    @image.path = img
    #@image.scale(@scale, @scale)
  end

  def three_button(button1, proc1, button2, proc2, button3, proc3)
    flow do
      stack(width: $col_0) { button (button1) { proc1.call } }
      stack(width: $col_1) { button (button2) { proc2.call } }
      stack(width: $col_2) { button (button3) { proc3.call } }
    end
  end

  def button_title_field(button, button_proc, field_legend, setup_edit_line_proc)
    flow do
      stack(width: $col_0) { button(button)  { button_proc.call } }
      stack(width: $col_1) { para(field_legend) }
      stack(width: $col_2) { setup_edit_line_proc.call  }
    end
  end

  def title_field(title, setup_edit_line_proc)
    flow do
      stack(width: $col_0) {}
      stack(width: $col_1) { para title }
      stack(width: $col_2) { setup_edit_line_proc.call }
    end
  end

  @controller = Controller.new
  @controller.slf = self

  three_button( 'dir',  proc { @controller.dir },
               'prev',  proc { @controller.previous },
               'next',  proc { @controller.next } )

  button_title_field( 'test', proc { @controller.test }, 'original', proc { @original_fn = edit_line } )

  title_field( 'description', proc { @description = edit_line } )

  title_field( 'current', proc { @current_fn = edit_line } )

  flow do
    stack(width: '100%') do
      @image = image('/Users/mark/RubymineProjects/photo-renamer/images/no_renderer.jpg', top: 0, left: 0)
    end
  end

  flow do
    @scale=1.0
    stack(width: $col_2) {para '-------' }
  end

end