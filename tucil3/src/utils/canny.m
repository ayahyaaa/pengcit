function imgout = canny(imgin)
    % Operator Canny untuk Edge Detection
    % Diawali dengan melakukan penghalusan citra, kemudian memanfaatkan gradien dari operator gradien dan tresholding
    % Terdapat 2 nilai treshold sehingga dapat menemukan tepi kuat dan tepi lemah
    % Memanfaatkan fungsi bawaan matlab
    imgout = edge(rgb2gray(imgin), 'Canny', 0.11, 1.5);
    imgout = uint8(imgout);
end

