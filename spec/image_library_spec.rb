require './spec/support/spec_helper'

describe Image do

  def test_file_root
    ruby_root + '/spec/image_library/'
  end

  def std_file_root
    ruby_root + '/images/'
  end

  let(:dir) { Dir.pwd+'/spec/image_library/' }

  let(:image_library) { Image.new(dir) }
  let(:lenovo_file_name) { ImageFileName.new(image_library.next) }

  let(:short_file_name_1) { '2010-01-01 00.13  c  .jpg' }
  let(:short_file_name_2) { 'IMG_20160725_103317.jpg' }
  let(:short_file_name_3) { 'russian digital collage.jpg' }
  let(:short_file_name_5) { 'text.txt' }
  let(:short_file_name_4) { 'test no extension' }
  let(:full_file_name_1) { test_file_root + short_file_name_1 }
  let(:full_file_name_2) { test_file_root + short_file_name_2 }
  let(:full_file_name_3) { test_file_root + short_file_name_3 }
  let(:full_file_name_4) { test_file_root + short_file_name_4 }
  let(:full_file_name_5) { test_file_root + short_file_name_5 }

  let(:short_file_name_4_image) { 'no_renderer.jpg' }
  let(:short_file_name_5_image) { 'no_renderer.jpg' }
  let(:full_file_name_4_image) { std_file_root + short_file_name_4_image }
  let(:full_file_name_5_image) { std_file_root + short_file_name_5_image }

  def copy_file(short_file_name)
    from_dir = ruby_root + '/spec/image_setup/'
    to_dir = ruby_root + '/spec/image_library/'
    FileUtils.copy(from_dir+short_file_name, to_dir+short_file_name)
  end

  before do
    to_dir = ruby_root + '/spec/image_library'
    FileUtils.rm_f(Dir.glob("#{to_dir}/*"))
    [short_file_name_1, short_file_name_2, short_file_name_3, short_file_name_4, short_file_name_5 ].each do |fn|
        copy_file(fn)
    end
    image_library
  end

  it "should reset" do
    expect( image_library.next ).to eq full_file_name_1
  end

  it "should NOT rename a file if it has the same name" do
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.change_name( short_file_name_1 ) ).to be false
    expect( image_library.short_file_name ).to eq short_file_name_1
    expect( image_library.full_file_name ).to eq full_file_name_1
  end

  it "should NOT rename a file if it has the same name elsewhere in the directory" do
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.change_name(short_file_name_2) ).to be false
    expect( image_library.short_file_name ).to eq short_file_name_1
    expect( image_library.full_file_name ).to eq full_file_name_1
  end

  it "should rename a file if it has a different name not elsewhere in directory" do
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.change_name( short_file_name_1+'x' ) ).to be true
    expect( image_library.short_file_name ).to eq short_file_name_1+'x'
    expect( image_library.full_file_name ).to eq full_file_name_1+'x'
  end

  it "should reveal the full and short file names and inserted text while incrementing" do
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.full_file_name ).to eq full_file_name_1
    expect( image_library.short_file_name ).to eq short_file_name_1
    expect( image_library.inserted_text ).to eq 'c'

    expect( image_library.next ).to eq full_file_name_2
    expect( image_library.full_file_name ).to eq full_file_name_2
    expect( image_library.short_file_name ).to eq short_file_name_2
    expect( image_library.inserted_text ).to eq ''

    expect( image_library.next ).to eq full_file_name_3
    expect( image_library.full_file_name ).to eq full_file_name_3
    expect( image_library.short_file_name ).to eq short_file_name_3
    expect( image_library.inserted_text ).to eq ''

    expect( image_library.next ).to eq full_file_name_4_image
    expect( image_library.full_file_name ).to eq full_file_name_4
    expect( image_library.short_file_name ).to eq short_file_name_4
    expect( image_library.inserted_text ).to eq ''

    expect( image_library.next ).to eq full_file_name_5_image
    expect( image_library.full_file_name ).to eq full_file_name_5
    expect( image_library.short_file_name ).to eq short_file_name_5
    expect( image_library.inserted_text ).to eq ''
  end

  it "should reveal correct image file names while cycling" do
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.previous ).to eq full_file_name_5_image
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.next ).to eq full_file_name_2
    expect( image_library.next ).to eq full_file_name_3
    expect( image_library.next ).to eq full_file_name_4_image
    expect( image_library.next ).to eq full_file_name_5_image
    expect( image_library.next ).to eq full_file_name_1
    expect( image_library.previous ).to eq full_file_name_5_image
    expect( image_library.previous ).to eq full_file_name_4_image
    expect( image_library.previous ).to eq full_file_name_3
    expect( image_library.previous ).to eq full_file_name_2
    expect( image_library.previous ).to eq full_file_name_1
    expect( image_library.previous ).to eq full_file_name_5_image
    expect( image_library.previous ).to eq full_file_name_4_image
  end

  it "should scale" do
    available_xy = 400

    image_library.next
    expect( image_library.size ).to eq [2304, 4096]
    expect( image_library.scale_factor(available_xy) ).to eq 0.09765625

    image_library.next
    image_library.next
    expect( image_library.size ).to eq [1049, 855]
    expect( image_library.scale_factor(available_xy) ).to eq 0.3813155386081983

    expect( image_library.scale_factor(2000) ).to eq 1.0
    expect( image_library.scale_factor(1000) ).to eq 0.9532888465204957
    expect( image_library.scale_factor(500) ).to eq 0.47664442326024786


  end
end
