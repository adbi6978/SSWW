# SSWW
Steady Shallow Water Waves code repo


# Running the Code 
ftp_class is for making the object, and the inputs are the address fo the refrence and data images.

ftp_class('address of the ref image', 'address of the data image');

widthHeight property is for setting the length that you want the square to have

widthHeight = length_of_square

transfrom is for making the 3D plot of the data image

## Optional parameters

you can set the upper left point that you want the cropping region to start at with xmin and ymin.

## example: 
obj = ftp_class('C:\Users\DHS\water-table\dispersive-hydrodynamics\IMG_0002b.CR2', 'C:\Users\DHS\water-table\dispersive-hydrodynamics\IMG_0001b.CR2');

myObj.widthHeight = 1500;

myObj.transform();

# To do list
## short term

Indexing by column/row (matlab is column major) (still need to transpose the ifft(fft(hilbert))) and reindex)

Median Filtering alternative

Unwrap phase, use splines? (or something else)

## long term ~ 1 month
2-D code

Data managment + storeage

Ease of use
-make a "how to run the code" document

Automate image cropping
