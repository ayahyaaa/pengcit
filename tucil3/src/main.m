img = imread('img/banana.png');

laplaceimg = laplace(img,'normal');
logimg = lapofgauss(img);
sobelimg = sobel(img, 2);
prewittimg = prewitt(img);
robertsimg = roberts(img);
cannyimg = canny(img);

figure, imshow(img);
figure, imshow(laplaceimg);
figure, imshow(logimg);
figure, imshow(sobelimg);
figure, imshow(prewittimg);
figure, imshow(robertsimg);
figure, imshow(cannyimg);