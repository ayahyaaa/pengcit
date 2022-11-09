function imgout = lapofgauss(imgin)
    % Operator Laplace of Gaussian untuk Edge Detection
    % Menggunakan metode yang sama dengan Laplace namun citra dihaluskan terlebih dahulu menggunakan penapis gaussian
    % Penapis awal Gaussian dari PPT menggunakan [1/16 1/8 1/16; 2/16 4/16 2/16; 1/16 1/8 1/16]
    % Mask Laplace awal dari PPT menggunakan [0 1 0; 1 -4 1; 0 1 0]

    m = 5; % penapis gaussian 5x5
    gaussian = zeros(m, m); % init penapis gauss
    center = double(idivide(m, int8(2))) + 1; % titik tengah penapis

    sigma = 1.5;
    for i=1:m
        for j=1:m
            gaussian(i, j) = 1 / (2 * pi * sigma) * exp(-((i-center) ^ 2 + (j-center) ^ 2) / (2 * sigma ^ 2));
        end
    end

    gaussian = gaussian / sum(gaussian(:)); % normalisasi penapis
    imgsmooth = uint8(convn(double(imgin),double(gaussian)));
    imgout = laplace(imgsmooth, 'gaussian');
end

