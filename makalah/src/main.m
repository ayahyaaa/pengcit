img = imread('img/imgmakalah4.png');
img = imadjustn(img);
imgin = im2gray(img);

cannyimg = edge(imgin, 'Canny');

% figure('Name','Original Image','NumberTitle','off'),imshow(img),
% figure('Name','Canny Image','NumberTitle','off'),imshow(cannyimg);

% figure('Name','Laplace Image','NumberTitle','off'),imshow(laplaceimg);
% figure('Name','LoG Image','NumberTitle','off'),imshow(logimg);
% figure('Name','Sobel Image','NumberTitle','off'),imshow(sobelimg);
% figure('Name','Prewitt Image','NumberTitle','off'),imshow(prewittimg);
% figure('Name','Roberts Image','NumberTitle','off'),imshow(robertsimg);
% figure('Name','Canny Image','NumberTitle','off'),imshow(cannyimg);

segmented1 = raidsegmentation(cannyimg, img);
figure, imshow(segmented1);
% segmented2 = segmentation(cannyimg, img, 'canny');
% figure, imshow(segmented2);

% newimg = edge(imgin,'Canny');
% figure, imshow(newimg);