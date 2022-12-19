img = imread('img/sample3.png');
img = imadjustn(img);
figure, imshow(img);
imgin = im2gray(img);

laplaceimg = laplace(imgin,'normal');
logimg = edge(imgin, 'log');
sobelimg = edge(imgin, 'Sobel');
prewittimg = edge(imgin, 'Prewitt');
robertsimg = edge(imgin, 'Roberts');
cannyimg = edge(imgin, 'Canny');

figure('Name','Original Image','NumberTitle','off'),
subplot(3,3,1),imshow(img),
subplot(3,3,2),imshow(laplaceimg);
subplot(3,3,3),imshow(logimg),
subplot(3,3,4),imshow(sobelimg),
subplot(3,3,5),imshow(prewittimg),
subplot(3,3,6),imshow(robertsimg),
subplot(3,3,7),imshow(cannyimg),

% figure('Name','Laplace Image','NumberTitle','off'),imshow(laplaceimg);
% figure('Name','LoG Image','NumberTitle','off'),imshow(logimg);
% figure('Name','Sobel Image','NumberTitle','off'),imshow(sobelimg);
% figure('Name','Prewitt Image','NumberTitle','off'),imshow(prewittimg);
% figure('Name','Roberts Image','NumberTitle','off'),imshow(robertsimg);
% figure('Name','Canny Image','NumberTitle','off'),imshow(cannyimg);

% segmented = segmentation(cannyimg, img, 'canny');
% figure, imshow(segmented);

% newimg = edge(imgin,'Canny');
% figure, imshow(newimg);