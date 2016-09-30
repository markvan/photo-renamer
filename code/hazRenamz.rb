$col_0 = '15%'
$col_1 = '25%'
$col_2 = '60%'

require 'controller'

Shoes.app do


  def three_button(button1, proc1, button2, proc2, button3, proc3)
    flow do
      stack(width: $col_0) { button (button1) { proc1.call } }
      stack(width: $col_1) { button (button2) { proc2.call } }
      stack(width: $col_2) { button (button3) { proc3.call } }
    end
  end

  def button_title_field(button, button_proc, field_ledgend, setup_edit_line_proc)
    flow do
      stack(width: $col_0) { button(button)  { button_proc.call } }
      stack(width: $col_1) { para(field_ledgend) }
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

  controller = Controller.new
  controller.slf = self

  three_button( 'dir',  proc { @image.path = '/Users/mark/RubymineProjects/photo-renamer/images/folder.jpg'},
               'prev',  proc { controller.prev },
               'next',  proc { controller.next } )

  button_title_field( 'test', proc { controller.test }, 'original', proc { @original_fn = edit_line } )

  title_field( 'description', proc { @description = edit_line } )

  title_field( 'current', proc { @current_fn = edit_line } )

  flow do
    stack(width: $col_3) do
      @image = image('/Users/mark/RubymineProjects/photo-renamer/images/no_renderer.jpg')
    end
  end

  flow do
    stack(width: $col_3) {para '-------' }
  end

end