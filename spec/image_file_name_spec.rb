require './spec/support/spec_helper'

describe ImageFileName do

  let(:dir) { Dir.pwd+'/spec/image_library/' }
  let(:full_file_name) { dir+short_file_name }
  let(:image_library) { ImageLibrary.new(dir) }
  let(:lenovo_file_name){ ImageFileName.new(image_library.next_image.file) }

  describe "for lenovo" do

    let(:short_file_name) { 'IMG_20160403_172718.jpg' }

    before do
      File.rename(ImageLibrary.new(dir).next_image.file, full_file_name)
      image_library
    end

    it "should reset" do
      expect(image_library.next_image.file).to eq full_file_name
    end



    it "should not be recognised as transformed" do
      expect(lenovo_file_name.matches_transformed?).to be false
    end

    it "should not have any inserted text" do
      expect(lenovo_file_name.inserted_text).to eq ''
    end

  end

  describe "transformed file names" do

    let(:short_file_name) { '2016.04.03__17.27 .jpg' }

    it "should recognise a transformed file name" do
      transformed_file_name = ImageFileName.new(full_file_name)
      expect(transformed_file_name.matches_transformed?).to be_truthy
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27  saving lives .jpg')
      expect(transformed_file_name.matches_transformed?).to be_truthy
    end

    it "should reveal the correct inserted text" do
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27.jpg')
      expect(transformed_file_name.inserted_text).to eq ''
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27 .jpg')
      expect(transformed_file_name.inserted_text).to eq ''
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27    .jpg')
      expect(transformed_file_name.inserted_text).to eq ''

      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27 saving lives .jpg')
      expect(transformed_file_name.inserted_text).to eq 'saving lives'
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27  saving lives .jpg')
      expect(transformed_file_name.inserted_text).to eq 'saving lives'
      transformed_file_name = ImageFileName.new(dir+'2016.04.03__17.27    saving lives   .jpg')
      expect(transformed_file_name.inserted_text).to eq 'saving lives'
    end
  end
end