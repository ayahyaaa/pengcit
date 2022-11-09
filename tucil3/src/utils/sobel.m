function imgout = sobel(imgin, c)
    % Operator Sobel untuk Edge Detection
    % Merupakan magnitudo dari gradien Sx dan Sy yang dikonvolusikan dengan citra
    % Magnitudo M = sqrt(Sx^2 + Sy^2)
    % Mask awal dari PPT untuk Sx = [-1 0 1; -c 0 c; -1 0 1];
    % Mask awal dari PPT untuk Sy = [1 c 1; 0 0 0; -1 -c -1];
    % dengan c adalah konstanta
    
    Sx = [-1 0 1; -c 0 c; -1 0 1];
    Sy = [1 c 1; 0 0 0; -1 -c -1];
    Jx = convn(double(imgin), double(Sx), 'same');
    Jy = convn(double(imgin), double(Sy), 'same');
    imgout = uint8(sqrt(Jx.^2 + Jy.^2));
end

