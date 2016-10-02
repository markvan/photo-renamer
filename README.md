## A photo and screenshot renamer

Being sick of seeing increasing numbers of screenshots and digital photos with names that do not reflect their
contents I thought I'd write something to tame my growing problem.

This is the result of that thought. Use the program to choose a directory of files to rename, and start entering differences.
You can try things out via the 'test' button.

Filenames of various types are recognised, pictures are displayed and the user can change filenames to a standard format thus:

Changed filenames are all of the form 
  yyy-mm-dd hh.mm  description entered  .ext
ext is one of png, jpg and gif.

## Running

ruby code/hasRenamez.rb


## What's what?

Master contains the currently favoured version. It's written using Ruby/Tk. You probably have to do a few things to get 
it running. Particularly using bundler to install gems.

imagescience is the other branch of interest; it uses Shoes and ImageScience, and is still in development. 
The reason for this branch is to (eventually) be able to distribute this system as a stand alone binary, no specific 
install magic needed.

Currently the system deals with file names in three formats: png, jpg and gif. Tiff will likely never be supported.


## Different format filenames

Do something sensible with patterns.rb if you want to transfrom different filenames to me.

If one of your patterns messes with recognition of the transformed format for output, 
then you need to alter matches_transformed? in code/image_file_name.rb. 
In fact my samsung pattern is delat with in that fashion in that method.

If you want to transform files like IMG_123456789.jpg ie where there is no date and time info in the filename, 
that is possible, but you'll have to delve a little deeper. 
Look at how I do this for the Lumix pattern where I extract EXIF data from photos to add time and date info
into the transformed filename.



## Notes for me

install imagemagik

    brew install imagemagick
  
check its working

    convert -version
    
