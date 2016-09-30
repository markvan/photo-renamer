require './spec/support/spec_helper'

describe Controller do
  it "should provide an image" do
    contrlr = Controller.new
    contrlr.test
    im = contrlr.image
    expect( im.class ).to be Image
    im.next
    expect( im.short_file_name ).to eq '2005-05-09 23.17.59.jpg'
    expect( im.size ).to eq [500, 338]
    expect( im.scale_factor(250) ).to eq 0.5
    expect( im.scale_factor(499) ).to eq 0.998
    expect( im.scale_factor(500) ).to eq 1.0
    expect( im.scale_factor(501) ).to eq 1.0


  end
end