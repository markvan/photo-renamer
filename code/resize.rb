require 'image_science'




ImageScience.with_image('/Users/mark/RubymineProjects/photo-renamer/images/folder.jpg') do |img|
  file = '/Users/mark/RubymineProjects/photo-renamer/images/folder'
  img.cropped_thumbnail(100) do |thumb|
    thumb.save "#{file}_cropped.png"
  end

  img.thumbnail(100) do |thumb|
    thumb.save "#{file}_thumb.png"
  end

  img.resize(100, 150) do |img2|
    img2.save "#{file}_resize.png"
  end
end