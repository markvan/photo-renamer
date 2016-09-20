require './spec/support/spec_helper'

describe Image do

  let(:dir) { Dir.pwd+'/spec/image_library/' }

  let(:image_library) { Image.new(dir) }
  let(:lenovo_file_name) { ImageFileName.new(image_library.next_image.file) }

  let(:short_file_name_1) { '2016.05.09__17.52  some text .jpg' }
  let(:short_file_name_2) { 'IMG_20160402_090136.jpg' }
  let(:short_file_name_3) { 'russian digital collage.jpg' }
  let(:short_file_name_4) { 'test no extension' }
  let(:short_file_name_4_image) { '/images/no_renderer.jpg' }
  let(:short_file_name_5) { 'text.txt' }
  let(:short_file_name_5_image) { '/images/no_renderer.jpg' }
  let(:full_file_name_1) { dir+short_file_name_1 }
  let(:full_file_name_2) { dir+short_file_name_2 }
  let(:full_file_name_3) { dir+short_file_name_3 }
  let(:full_file_name_4) { dir+short_file_name_4 }
  let(:full_file_name_4_image) { Dir.pwd+short_file_name_4_image }
  let(:full_file_name_5) { dir+short_file_name_5 }
  let(:full_file_name_5_image) { Dir.pwd+short_file_name_5_image }

  before do
    File.rename(Image.new(dir).next_image.file, full_file_name_1)
    image_library
  end

  it "should reset" do
    expect(image_library.next_image.file).to eq full_file_name_1
  end

  it "should rename a file" do
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.change_name(short_file_name_1)).to be false
  end

  it "should not rename an existing file" do
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.change_name(short_file_name_1)).to be true
  end

  it "should not rename a file with an existing file name in the directory" do
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.change_name( full_file_name_2 )).to be false
  end

  it "should reveal the full and short file names and inserted text while incrementing" do
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.full_file_name).to eq full_file_name_1
    expect(image_library.short_file_name).to eq short_file_name_1
    expect(image_library.inserted_text).to eq 'some text'

    expect(image_library.next_image.file).to eq full_file_name_2
    expect(image_library.full_file_name).to eq full_file_name_2
    expect(image_library.short_file_name).to eq short_file_name_2
    expect(image_library.inserted_text).to eq ''

    expect(image_library.next_image.file).to eq full_file_name_3
    expect(image_library.full_file_name).to eq full_file_name_3
    expect(image_library.short_file_name).to eq short_file_name_3
    expect(image_library.inserted_text).to eq ''

    expect(image_library.next_image.file).to eq full_file_name_4_image
    expect(image_library.full_file_name).to eq full_file_name_4
    expect(image_library.short_file_name).to eq short_file_name_4
    expect(image_library.inserted_text).to eq ''

    expect(image_library.next_image.file).to eq full_file_name_5_image
    expect(image_library.full_file_name).to eq full_file_name_5
    expect(image_library.short_file_name).to eq short_file_name_5
    expect(image_library.inserted_text).to eq ''
  end

  it "should reveal correct image file names while cycling" do
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.previous_image.file).to eq full_file_name_5_image
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.next_image.file).to eq full_file_name_2
    expect(image_library.next_image.file).to eq full_file_name_3
    expect(image_library.next_image.file).to eq full_file_name_4_image
    expect(image_library.next_image.file).to eq full_file_name_5_image
    expect(image_library.next_image.file).to eq full_file_name_1
    expect(image_library.previous_image.file).to eq full_file_name_5_image
    expect(image_library.previous_image.file).to eq full_file_name_4_image
    expect(image_library.previous_image.file).to eq full_file_name_3
    expect(image_library.previous_image.file).to eq full_file_name_2
    expect(image_library.previous_image.file).to eq full_file_name_1
    expect(image_library.previous_image.file).to eq full_file_name_5_image
    expect(image_library.previous_image.file).to eq full_file_name_4_image
  end
end
