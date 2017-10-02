img = imread('IMG_0002.CR2');

img2 = imcrop(img,[2000 1000 1500 1500]);

%cropping is imcrop(im,[xmin ymin width height])

figure;
subplot(1,2,1)
imshow(img)
title('Original Image')
subplot(1,2,2)
imshow(img2)
title('Cropped Image')

%subplot(1,2,1)
%imshow(imgg)
%title('Original Image')
%subplot(1,2,2)
%imshow(imgg2)
%title('Cropped Image')