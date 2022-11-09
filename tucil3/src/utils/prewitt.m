function imgout = prewitt(imgin)
    % Operator Prewitt untuk Edge Detection
    % Merupakan operator sobel yang menggunakan konstanta c = 1
    imgout = sobel(imgin, 1);
end