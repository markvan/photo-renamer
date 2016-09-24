require './spec/support/spec_helper'

describe ImageFileName do

  def make_fn(str)
    ImageFileName.new(str)
  end

  describe "instantiation" do
    it "should work from short and full path filenames" do
      expect(make_fn('IMG_20160725_103317.jpg').short_file_name).to eq 'IMG_20160725_103317.jpg'
      expect(make_fn('/some/path/to /IMG_20160725_103317.jpg').short_file_name).to eq 'IMG_20160725_103317.jpg'
    end
  end

  describe "matching" do
    it "should match lenovo original formats" do
      expect(make_fn('IMG_20160725_103317.jpg').matches_lenovo?).to be_truthy
      expect(make_fn('IMG_20100101_001301.jpg').matches_any_original?).to be_truthy
      expect(make_fn('IMG_20100101_001301.jpg').matches_transformed?).to eq false
    end

    it "should FAIL to recognise arbitrary as lenovo" do
      expect(make_fn('20160725_103317.jpg').matches_lenovo?).to eq false
      expect(make_fn('20100101_001301.jpg').matches_any_original?).to eq false
      expect(make_fn('20100101_001301.jpg').matches_transformed?).to eq false
    end

    it "should match screenshot original formats" do
      expect(make_fn('Screen Shot 2016-09-20 at 00.04.40.png').matches_screenshot?).to be_truthy
      expect(make_fn('Screen Shot 2016-09-20 at 00.04.40.png').matches_any_original?).to be_truthy
      expect(make_fn('Screen Shot 2016-09-20 at 00.04.40.png').matches_transformed?).to eq false
    end

    it "should match samsung ace original formats" do
      expect(make_fn('2005-05-09 23.17.59.jpg').matches_samsung_ace?).to be_truthy
      expect(make_fn('2005-05-09 23.17.59.jpg').matches_any_original?).to be_truthy
      expect(make_fn('2005-05-09 23.17.59.jpg').matches_transformed?).to eq false
    end

    it "should match transformed" do
      expect(make_fn('2016-07-25 10.33 .jpg').matches_transformed?).to be_truthy
      expect(make_fn('2016-07-25 10.33 xx .jpg').matches_transformed?).to be_truthy
      expect(make_fn('2016-07-25 10.33 xx yy .jpg').matches_transformed?).to be_truthy
      expect(make_fn('2016-07-25 10.33 .jpg').matches_transformed?).to be_truthy
      expect(make_fn('2016-07-25 10.33  xx  .jpg').matches_transformed?).to be_truthy
      expect(make_fn('2016-07-25 10.33  xx yy  .jpg').matches_transformed?).to be_truthy
      expect(make_fn('2016-07-25 10.33 .jpg').matches_lenovo?).to eq false
      expect(make_fn('2016-07-25 10.33 .jpg').matches_any_original?).to eq false
    end
  end

  describe "transformed file names" do

    it "should recognise inserted text" do
      expect(make_fn('2016-07-25 10.33 .jpg').inserted_text).to eq ''
      expect(make_fn('2016-07-25 10.33  .jpg').inserted_text).to eq ''
      expect(make_fn('2016-07-25 10.33 xx .jpg').inserted_text).to eq 'xx'
      expect(make_fn('2016-07-25 10.33 xx yy .jpg').inserted_text).to eq 'xx yy'
    end
  end

  describe "potential file names" do

    it "should show transformed filenames from lenovo file names" do
      expect(make_fn('IMG_20160121_051301.jpg').potential_new_filename('')).to eq 'IMG_20160121_051301.jpg'
      expect(make_fn('IMG_20160121_051301.jpg').potential_new_filename('xx')).to eq '2016-01-21 05.13  xx  .jpg'
      expect(make_fn('IMG_20160121_051301.jpg').potential_new_filename('xx yy')).to eq '2016-01-21 05.13  xx yy  .jpg'
    end

    it "should show transformed filenames from screenshot file names" do
      expect(make_fn('Screen Shot 2016-09-20 at 00.04.40.png').potential_new_filename('')).to eq 'Screen Shot 2016-09-20 at 00.04.40.png'
      expect(make_fn('IMG_20160121_051301.jpg').potential_new_filename('xx')).to eq '2016-01-21 05.13  xx  .jpg'
      expect(make_fn('IMG_20160121_051301.jpg').potential_new_filename('xx yy')).to eq '2016-01-21 05.13  xx yy  .jpg'
    end

    it "should show transformed filenames from transformed file names" do
      expect(make_fn('2016-04-03 17.27.jpg').potential_new_filename('')).to eq '2016-04-03 17.27 .jpg'
      expect(make_fn('2016-04-03 17.27 .jpg').potential_new_filename('')).to eq '2016-04-03 17.27 .jpg'
      expect(make_fn('2016-04-03 17.27  .jpg').potential_new_filename('')).to eq '2016-04-03 17.27 .jpg'
    end
  end

end