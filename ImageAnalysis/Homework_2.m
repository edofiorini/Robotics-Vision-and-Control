%% Analysis of the image with 2 coins and one pen drive

clear all; close all; clc;

%Read an image into the workspace.
I = imread('mycoins_bw.png');
%I = imread('IMAGE.jpg');
imshow(I)

% I = rgb2gray( I );
 %imshow(I)

%The background illumination is brighter in the center of the image than at the bottom.
%Preprocess the image to make the background illumination more uniform.
%As a first step, remove all of the foreground (rice grains) using morphological opening.
%The opening operation removes small objects that cannot completely contain the structuring element.
%Define a disk-shaped structuring element with a radius of 15, which fits entirely inside a single grain of rice.
se = strel('disk',500);

%To perform the morphological opening, use imopen with the structuring element.
background = imopen(I,se);
imshow(background)

%Subtract the background approximation image, background, from the original image, I, and view the resulting image.
%After subtracting the adjusted background image from the original image, 
%the resulting image has a uniform background but is now a bit dark for analysis.
I2 = I - background;
imshow(I2)

%Use imadjust to increase the contrast of the processed image I2
%by saturating 1% of the data at both low and high intensities
%and by stretching the intensity values to fill the uint8 dynamic range.
I3 = imadjust(I2);
imshow(I3)

%Note that the prior two steps could be replaced by a single step
%using imtophat which first calculates the morphological opening and then subtracts it from the original image.
%I2 = imtophat(I,strel('disk',20));

%Create a binary version of the processed image so you can use toolbox functions for analysis. 
%Use the imbinarize function to convert the grayscale image into a binary image.
%Remove background noise from the image with the bwareaopen function.
bw = imbinarize(I3);
bw = bwareaopen(bw,200);
imshow(bw)




%Identify Objects in the Image
%Now that you have created a binary version of the original image you can perform analysis of objects in the image.
%Find all the connected components (objects) in the binary image. 
%The accuracy of your results depends on the size of the objects,
%the connectivity parameter (4, 8, or arbitrary),
%and whether or not any objects are touching (in which case they could be labeled as one object).
%Some of the rice grains in the binary image bw are touching.


%View the rice grain that is labeled 50 in the image. 
% grain = false(size(bw));
% grain(cc.PixelIdxList{50}) = true;
% imshow(grain)

%Visualize all the connected components in the image by creating a label matrix
%and then displaying it as a pseudocolor indexed image.
%Use labelmatrix to create a label matrix from the output of bwconncomp. 
%Note that labelmatrix stores the label matrix in the smallest numeric class necessary for the number of objects.


%Use label2rgb to choose the colormap, the background color, 
%and how objects in the label matrix map to colors in the colormap.
%In the pseudocolor image, the label identifying each object in the label matrix maps to a different color in an associated colormap matrix.


%boundary = imcontour(bw, 'r');
%Compute Area-Based Statistics
%Compute the area of each object in the image using regionprops. Each rice grain is one connected component in the cc structure.

bw = imfill(bw,'holes');
imshow(bw)

cc = bwconncomp(bw,4)
cc.NumObjects

labeled = labelmatrix(cc);
whos labeled

RGB_label = label2rgb(labeled,'spring','c','shuffle');
imshow(RGB_label)

stats = regionprops('table',bw,'Centroid',  'MajorAxisLength','MinorAxisLength', 'Area', 'Perimeter', 'BoundingBox');

centers = stats.Centroid;
areas = stats.Area;
major = stats.MajorAxisLength;
minor = stats.MinorAxisLength;
class = zeros(1,size(major,1) );

for i= 1: size(major,1)
    if major(i,1)/minor(i,1) > 1.1
        class(i) =  1;
    end
end      

circle_areas = [];
circle_centers = [];
circle_major = [];
circle_minor = [];
name_circle = [];
name_pen = [];
pen_centers = [];

for i= 1: size(class, 2)
    if class(i) == 0
        circle_centers = [circle_centers; centers(i,:)];
        circle_major = [circle_major; major(i,:)];
        circle_minor = [circle_minor; minor(i,:)];  
        circle_areas = [circle_areas; areas(i,:)];
        name_circle = [name_circle, "Coin"];
    else
        pen_centers = [pen_centers,centers(i,:) ];
        name_pen = [name_pen, "USB Pen"];
    end
end

diameters = mean([ circle_major circle_minor],2);
radii = diameters/2;

if circle_areas(1,1) > circle_areas(2,1)
    name_circle(1) = "Big Coin";
    name_circle(2) = "Small Coin";
else
    name_circle(2) = "Big Coin";
    name_circle(1) = "Small Coin";
end

new_centers = [circle_centers; pen_centers ];
name = [name_circle, name_pen];

imshow(I)
hold on
viscircles(circle_centers(1:2, :),radii(1:2,:));
hold on
for i = 1:size(centers,1)
    plot(centers(i,1), centers(i,2), '.r', 'MarkerSize', 10);
    text(centers(i,1), centers(i,2),name(i), 'Color','black','FontSize',14);
end
