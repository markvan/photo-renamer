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
  let(:lenovo_file_name) { ImageFileName.new(image_library.next.file) }

  let(:short_file_name_1) { '2016-05-09 17.52  some text .jpg' }
  let(:short_file_name_2) { 'IMG_20160402_090136.jpg' }
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

  def copy_file(new_full_name)
    source_file = ruby_root + '/spec/image_setup/russian digital collage.jpg'
    FileUtils.copy(source_file, new_full_name)
  end

  before do
    to_dir = ruby_root + '/spec/image_library'
    FileUtils.rm_f(Dir.glob("#{to_dir}/*"))
    [full_file_name_1, full_file_name_2, full_file_name_3, full_file_name_4, full_file_name_5 ].each do |fn|
        copy_file(fn)
    end
    image_library
  end

  it "should reset" do
    expect(image_library.next.file).to eq full_file_name_1
  end

  it "should NOT rename a file if it has the same name" do
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.change_name(short_file_name_1)).to be false
    expect(image_library.short_file_name).to eq short_file_name_1
    expect(image_library.full_file_name).to eq full_file_name_1
  end

  it "should NOT rename a file if it has the same name elsewhere in the directory" do
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.change_name(short_file_name_2)).to be false
    expect(image_library.short_file_name).to eq short_file_name_1
    expect(image_library.full_file_name).to eq full_file_name_1
  end

  it "should rename a file if it has a different name not elsewhere in directory" do
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.change_name(short_file_name_1+'x')).to be true
    expect(image_library.short_file_name).to eq short_file_name_1+'x'
    expect(image_library.full_file_name).to eq full_file_name_1+'x'
  end

  it "should reveal the full and short file names and inserted text while incrementing" do
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.full_file_name).to eq full_file_name_1
    expect(image_library.short_file_name).to eq short_file_name_1
    expect(image_library.inserted_text).to eq 'some text'

    expect(image_library.next.file).to eq full_file_name_2
    expect(image_library.full_file_name).to eq full_file_name_2
    expect(image_library.short_file_name).to eq short_file_name_2
    expect(image_library.inserted_text).to eq ''

    expect(image_library.next.file).to eq full_file_name_3
    expect(image_library.full_file_name).to eq full_file_name_3
    expect(image_library.short_file_name).to eq short_file_name_3
    expect(image_library.inserted_text).to eq ''

    expect(image_library.next.file).to eq full_file_name_4_image
    expect(image_library.full_file_name).to eq full_file_name_4
    expect(image_library.short_file_name).to eq short_file_name_4
    expect(image_library.inserted_text).to eq ''

    expect(image_library.next.file).to eq full_file_name_5_image
    expect(image_library.full_file_name).to eq full_file_name_5
    expect(image_library.short_file_name).to eq short_file_name_5
    expect(image_library.inserted_text).to eq ''
  end

  it "should reveal correct image file names while cycling" do
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.previous.file).to eq full_file_name_5_image
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.next.file).to eq full_file_name_2
    expect(image_library.next.file).to eq full_file_name_3
    expect(image_library.next.file).to eq full_file_name_4_image
    expect(image_library.next.file).to eq full_file_name_5_image
    expect(image_library.next.file).to eq full_file_name_1
    expect(image_library.previous.file).to eq full_file_name_5_image
    expect(image_library.previous.file).to eq full_file_name_4_image
    expect(image_library.previous.file).to eq full_file_name_3
    expect(image_library.previous.file).to eq full_file_name_2
    expect(image_library.previous.file).to eq full_file_name_1
    expect(image_library.previous.file).to eq full_file_name_5_image
    expect(image_library.previous.file).to eq full_file_name_4_image
  end
end
