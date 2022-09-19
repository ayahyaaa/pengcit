img = imread('Lena.bmp');
[rows, cols, rgb] = size(img);
feat = input("feature, 1 hist; 2 enhance; 3 histeq\n");
if feat == 1
    type = input("0/1\n");
    [xax, imghist] = proccHistogram(img,rows,cols,type);
    showHistogram(xax, imghist,type);
elseif feat == 2
    type = input("type=\n");
    newimg = enhImage(img,rows,cols,type);
else
    type = input("0/1\n");
    [xax, imghist] = proccHistogram(img,rows,cols,type);
    figure; imshow(img);
    newimg = equalizeHistogram(img, imghist, rows, cols);
    figure; imshow(newimg);
    [xax, imghist] = proccHistogram(newimg,rows,cols,type);
    showHistogram(xax, imghist,type);
    bcd = histeq(img);
    figure; imshow(img);
    figure; imhist(bcd);
end


function [xax, imghist] = proccHistogram(img,rows,cols,type)
    if isa(img,"double")
        img = img*256;
    end
    if type == 1
        imghist = zeros(1,256);
        xax = 1:256;
        for c = 1:cols
            for r = 1:rows
                pixval = img(r,c);
                if pixval > 256
                    pixval = 256;
                elseif pixval < 1
                    pixval = 1;
                end
                imghist(int64(pixval)) = imghist(int64(pixval)) + 1;
            end
        end
    else
        imghist = zeros(1,256);
        imghist(:,:,2) = 0;
        imghist(:,:,3) = 0;
        for i = 1:3
            xax = 1:256;
            for c = 1:cols
                for r = 1:rows
                    pixval = img(r,c,i);
                    if pixval > 256
                        pixval = 256;
                    elseif pixval < 1
                        pixval = 1;
                    end
                    imghist(:,int64(pixval),i) = imghist(:,int64(pixval),i) + 1;
                end
            end
        end   
    end
end

function showHistogram(axis,freq,type)
    if type == 1
        figure;
        bar(axis, freq);
        xlabel('Grayscale');
        ylabel('Frequency');
        grid off;
    else
        for i=1:3
            figure(i);
            bar(axis, freq(:,:,i));
            xlabel('Grayscale');
            ylabel('Frequency');
            grid on;
        end
    end
end

function newimg = enhImage(img,rows,cols,type)
    if type == 1
        a = input("a=");
        b = input("b=");
        newimg = img;
        for c = 1:cols
            for r = 1:rows
                newimg(r,c) = img(r,c)*a+b;
                if newimg(r,c) > 255
                    newimg(r,c) = 255;
                end
            end
        end
    elseif type == 2
        constant = input("c=");
        newimg = img;
        var = log(1+mat2gray(img));
        for c = 1:cols
            for r = 1:rows
                newimg(r,c) = constant*var(r,c);
                if newimg(r,c) > 255
                    newimg(r,c) = 255;
                elseif newimg(r,c) < 0
                    newimg(r,c) = 0;
                end
            end
        end
    elseif type == 3
        constant = input("c=");
        pow = input("pow=");
        var = im2double(img);
        newimg = constant * (var.^pow);
    elseif type == 4
        min = 257;
        max = 0;
        for c = 1:cols
            for r = 1:rows
                if min > img(r,c)
                    min = img(r,c);
                elseif max < img(r,c)
                    max = img(r,c);
                end
            end
        end
        newimg = (img - min).*(255/(max - min));
    end
end

% todo blom bener
function newimg = equalizeHistogram(img, imghist, rows, cols)
    inc = 0;
    newxax = 1:256;
    for i=1:256
        inc = inc + imghist(1,i);
        newxax(1,i) = (inc/(rows*cols))*256;
    end
    newxax = int64(newxax);
    newimg = img;
    for c = 1:cols
        for r = 1:rows
            newimg(r,c) = newxax(1,newimg(r,c));
        end
    end
end