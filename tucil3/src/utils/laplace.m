function imgout = laplace(imgin, mode)
    % Operator Laplace untuk Edge Detection
    % Menggunakan Mask Konvolusi, merupakan high-pass filter karena jumlah seluruh koefisien 0.
    % Mask awal dari PPT menggunakan [0 1 0; 1 -4 1; 0 1 0]
    mask = [0 2 0; 2 -8 2; 0 2 0];
    if strcmp(mode, 'gaussian')
        mask = [1 2 1; 2 -12 2; 1 2 1];
    end
    imgout = uint8(convn(double(imgin),double(mask)));
end

