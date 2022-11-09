function imgout = roberts(imgin)
    % Operator Roberts untuk Edge Detection
    % Disebut juga operator silang karena menggunakan mask konvolusi silang
    % Mask yang digunakan adalah
    % Rx = [1 0; 0 -1];
    % Ry = [0 1; -1 0];
    Rx = [1 0; 0 -1];
    Ry = [0 1; -1 0];
    Jx = convn(double(imgin), double(Rx), 'same');
    Jy = convn(double(imgin), double(Ry), 'same');
    imgout = uint8(sqrt(Jx.^2 + Jy.^2));
end
