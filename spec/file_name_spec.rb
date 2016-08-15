require './spec/support/spec_helper'

describe "file names" do

  let(:dir) { Dir.pwd+'/spec/image_library/' }
  let(:full_file_name) { dir+short_file_name }
  let(:picture_library) { PictureLibrary.new(dir) }

  describe "for lenovo" do

    let(:short_file_name) { 'IMG_20160403_172718.jpg' }

    before do
      File.rename(PictureLibrary.new(dir).next_image.file, full_file_name)
      picture_library
    end

    it "should reset" do
      expect(picture_library.next_image.file).to eq full_file_name
    end

    it "should setup" do
      lenovo_file_name = ImageFileName.new(picture_library.next_image.file)
      expect(lenovo_file_name.short_file_name).to eq short_file_name
      expect(lenovo_file_name.full_file_name).to eq full_file_name
      expect(lenovo_file_name.directory).to eq dir
    end

    it "should recognise a lenovo file name" do
      lenovo_file_name = ImageFileName.new(picture_library.next_image.file)
      expect(lenovo_file_name.is_lenovo?).to be true
    end
  end

  describe "transformed file names" do

    let(:short_file_name) { '2016.04.03__17.27 .jpg' }

    it "should recognise a transformed file name" do
      transformed_file_name = ImageFileName.new(full_file_name)
      expect(transformed_file_name.is_transformed?).to be true
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27 saving lives .jpg')
      expect(transformed_file_name.is_transformed?).to be true
    end
  end
end