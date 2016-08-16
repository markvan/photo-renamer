require './spec/support/spec_helper'

describe "file names" do

  let(:dir) { Dir.pwd+'/spec/image_library/' }

  let(:picture_library) { ImageLibrary.new(dir) }
  let(:lenovo_file_name) { ImageFileName.new(picture_library.next_image.file) }

  let(:short_file_name_1) { '2016.05.09__17.52  some text .jpg' }
  let(:short_file_name_2) { 'IMG_20160402_090136.jpg' }
  let(:short_file_name_3) { 'russian digital collage.jpg' }
  let(:short_file_name_4) { 'test no extension' }
  let(:short_file_name_4_image) { '/code/picture.jpg' }
  let(:short_file_name_5) { 'text.txt' }
  let(:short_file_name_5_image) { '/code/picture.jpg' }
  let(:full_file_name_1) { dir+short_file_name_1 }
  let(:full_file_name_2) { dir+short_file_name_2 }
  let(:full_file_name_3) { dir+short_file_name_3 }
  let(:full_file_name_4) { dir+short_file_name_4 }
  let(:full_file_name_4_image) { Dir.pwd+short_file_name_4_image }
  let(:full_file_name_5) { dir+short_file_name_5 }
  let(:full_file_name_5_image) { Dir.pwd+short_file_name_5_image }

  before do
    picture_library
  end

  it "should reveal the file names" do
    expect(picture_library.next_image.file).to eq full_file_name_1
    expect(picture_library.full_file_name).to eq full_file_name_1
    expect(picture_library.short_file_name).to eq short_file_name_1
    expect(picture_library.inserted_text).to eq 'some text'

    expect(picture_library.next_image.file).to eq full_file_name_2
    expect(picture_library.full_file_name).to eq full_file_name_2
    expect(picture_library.short_file_name).to eq short_file_name_2
    expect(picture_library.inserted_text).to eq ''

    expect(picture_library.next_image.file).to eq full_file_name_3
    expect(picture_library.full_file_name).to eq full_file_name_3
    expect(picture_library.short_file_name).to eq short_file_name_3
    expect(picture_library.inserted_text).to eq ''

    expect(picture_library.next_image.file).to eq full_file_name_4_image
    expect(picture_library.full_file_name).to eq full_file_name_4
    expect(picture_library.short_file_name).to eq short_file_name_4
    expect(picture_library.inserted_text).to eq ''

    expect(picture_library.next_image.file).to eq full_file_name_5_image
    expect(picture_library.full_file_name).to eq full_file_name_5
    expect(picture_library.short_file_name).to eq short_file_name_5
    expect(picture_library.inserted_text).to eq ''



  end

  it "should cycle" do
    expect(picture_library.next_image.file).to eq full_file_name_1
    expect(picture_library.previous_image.file).to eq full_file_name_5_image
    expect(picture_library.next_image.file).to eq full_file_name_1
    expect(picture_library.next_image.file).to eq full_file_name_2
    expect(picture_library.next_image.file).to eq full_file_name_3
    expect(picture_library.next_image.file).to eq full_file_name_4_image
    expect(picture_library.next_image.file).to eq full_file_name_5_image
    expect(picture_library.next_image.file).to eq full_file_name_1
    expect(picture_library.previous_image.file).to eq full_file_name_5_image
    expect(picture_library.previous_image.file).to eq full_file_name_4_image
    expect(picture_library.previous_image.file).to eq full_file_name_3
    expect(picture_library.previous_image.file).to eq full_file_name_2
    expect(picture_library.previous_image.file).to eq full_file_name_1
    expect(picture_library.previous_image.file).to eq full_file_name_5_image
    expect(picture_library.previous_image.file).to eq full_file_name_4_image
  end
end

describe "transformed file names" do

end