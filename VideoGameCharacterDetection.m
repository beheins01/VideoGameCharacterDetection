clear, clc, close all;
cd 'C:\Users\ben2h\OneDrive\Senior Year\Second Semester\Image Processing\Images';
ls('*.jpg')
ls('*.png')
ls('*.jpeg')

IMG = imread('CSGO23.png');
GrayIMG = rgb2gray(IMG);

G = fspecial('gaussian', [4 4], 2);
FilteredIMG = imfilter(GrayIMG, G, 'same');

U = edge(FilteredIMG, 'canny', [0.1 0.3]);

% Apply the Hough Transform to detect lines in the image
[H,theta,rho] = hough(U);

% Find the peaks in the Hough Transform
peaks = houghpeaks(H, 50);

% Extract the lines from the Hough Transform
lines = houghlines(U, theta, rho, peaks);

% Create a binary mask of the lines
mask = false(size(U));
for k = 1:length(peaks)
    idx = peaks(k,:);
    xy = houghlines(U,theta,rho,idx);
    xy = [xy.point1; xy.point2];
    x = xy(:,1);
    y = xy(:,2);
    linemask = poly2mask(x,y,size(U,1),size(U,2));
    mask = mask | linemask;
end

% Remove the circles from the image
U(mask) = 0;

figure;
imshow(U); title('Canny Image');