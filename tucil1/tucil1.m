img = imread('Lena.bmp');
[rows, cols, rgb] = size(img);

feat = input("feature, 1 hist; 2 enhance; 3 histeq; 4 histspec\n");
if feat == 1
    [xax, imghist] = proccHistogram(img,rows,cols,rgb);
    showHistogram(xax, imghist, rgb);
    figure; imshow(img);
elseif feat == 2
    type = input("1 bright; 2 log; 3 power; 4 stretch\n")
    newimg = enhImage(img,rows,cols,rgb,type);
    [xax, imghist] = proccHistogram(newimg,rows,cols,rgb);
    showHistogram(xax, imghist, rgb);
    figure; imshow(newimg);
elseif feat == 3
    [xax, imghist] = proccHistogram(img,rows,cols,rgb);
    newimg = equalizeHistogram(img, imghist, rows, cols, rgb);
    [xax, imghist] = proccHistogram(newimg,rows,cols,rgb);
    showHistogram(xax, imghist,rgb);
    figure; imshow(newimg);
elseif feat==4
    newimg = specificationHistogram(img, rows, cols, rgb);
    figure(10); imshow(img);
    figure(11); imshow(newimg);
    [xax, imghist] = proccHistogram(newimg,rows,cols,rgb);
    showHistogram(xax, imghist,rgb);
end

function [xax, imghist] = proccHistogram(img,rows,cols,rgb)
    if isa(img,"double")
        img = img*256;
    end
    imghist = zeros(1,256);
    xax = 1:256;
    if (rgb>1)
        imghist(:,:,2) = 0;
        imghist(:,:,3) = 0;
    end
    for i = 1:rgb       
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

function showHistogram(axis,freq,rgb)
    for i=1:rgb
        figure(i);
        bar(axis, freq(:,:,i));
        xlabel('Grayscale');
        ylabel('Frequency');
        grid on;
    end
end

function newimg = enhImage(img,rows,cols,rgb,type)
    if type == 1
        a = input("a=");
        b = input("b=");
        newimg = img;
        for i = 1:rgb
            for c = 1:cols
                for r = 1:rows
                    newimg(r,c,i) = img(r,c,i)*a+b;
                    if newimg(r,c,i) > 255
                        newimg(r,c,i) = 255;
                    elseif newimg(r,c,i) < 0
                        newimg(r,c,i) = 0;
                    end
                end
            end
        end
    elseif type == 2
        constant = input("c=");
        newimg = img;
        var = log1p(mat2gray(img));
        for i = 1:rgb
            for c = 1:cols
                for r = 1:rows
                    newimg(r,c,i) = constant*var(r,c,i);
                    if newimg(r,c,i) > 255
                        newimg(r,c,i) = 255;
                    elseif newimg(r,c,i) < 0
                        newimg(r,c,i) = 0;
                    end
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
        for i = 1:rgb
            for c = 1:cols
                for r = 1:rows
                    if min > img(r,c,i)
                        min = img(r,c,i);
                    elseif max < img(r,c,i)
                        max = img(r,c,i);
                    end
                end
            end
            newimg(:,:,i) = (img(:,:,i) - min).*(255/(max - min));
        end
    end

end

% todo blom bener keknya au dah
function newimg = equalizeHistogram(img, imghist, rows, cols, rgb)
    newxax = 1:256;
    if (rgb>1)
        newxax(:,:,2) = 1:256;
        newxax(:,:,3) = 1:256;
    end
    for i = 1:rgb
        inc = 0;
        for j=1:256
            inc = inc + imghist(1,j,i);
            newxax(1,j,i) = (inc/(rows*cols))*256;
        end
    end
    newxax = int64(newxax);
    newimg = img;
    for i = 1:rgb
        for c = 1:cols
            for r = 1:rows
                if(img(r,c,i) == 0)
                    continue
                end
                newimg(r,c,i) = newxax(1,img(r,c,i),i);
            end
        end
    end
end

% allegedly ngikutin ppt, gatau dh bener apa kagak
function newimg = specificationHistogram(img, rows, cols, rgb)
    % [xax, imghist] = proccHistogram(img,rows,cols,rgb);
    % img1 = equalizeHistogram(img,imghist,rows,cols,rgb);
    % [xax, imghist] = proccHistogram(img1,rows,cols,rgb);
    
    % rgbspec = 0;
    % while(rgbspec ~= rgb)
    %     imgspec = imread('Lena512warna.bmp');
    %     [rowspec, colspec, rgbspec] = size(img);
    % end
    
    % [xax, imghist1] = proccHistogram(imgspec,rows,cols,rgbspec);
    % img2 = equalizeHistogram(imgspec,imghist1,rows,cols,rgbspec);
    % [xax, imghist1] = proccHistogram(img2,rows,cols,rgbspec);
    
    % invhist = 1:256;
    % if (rgb>1)
    %     invhist(:,:,2) = 0;
    %     invhist(:,:,3) = 0;
    % end
    % for i = 1:rgb
    %     for j = 1:cols
    %         minval = abs(imghist(1,j,i) - imghist1(1,j,i));
    %         mink = 0;
    %         for k = 1:256
    %             if abs(imghist(1,j,i) - imghist1(1,k,i))<minval
    %                 minval = abs(imghist(1,j,i) - imghist1(1,k,i));
    %                 mink = k;
    %             end
    %         invhist(1,j,i) = mink;
    %         end
    %     end
    % end
    
    % for i = 1:rgb
    %     for c = 1:cols
    %         for r = 1:rows
    %             if img(r,c,i) == 0
    %                 img(r,c,i) = 1;
    %             end
    %             newimg(r,c,i) = invhist(1,img(r,c,i),i);
    %         end
    %     end
    % end

    [xax, imghist] = proccHistogram(img,rows,cols,rgb);
    inc = 0;
    newxax = 1:256;
    if rgb>1
        newxax(:,:,2) = 1:256;
        newxax(:,:,3) = 1:256;
    end
    for layer=1:rgb
        inc = 0;
        for i=1:256
            inc = inc + imghist(1,i,layer);
            newxax(1,i,layer) = (inc/(rows*cols))*256;
        end
        newxax = int64(newxax);
        newimg = img;
    end
    newxax = int64(newxax);
    
    rgbspec = 0;
    while(rgbspec ~= rgb)
        imgspec = imread('bird.bmp');
        [rowspec, colspec, rgbspec] = size(imgspec);
    end

    [xax, imghist1] = proccHistogram(imgspec,rows,cols,rgbspec);
    newxax1 = 1:256;
    if rgbspec>1
        newxax1(:,:,2) = 1:256;
        newxax1(:,:,3) = 1:256;
    end
    for layer=1:rgbspec
        inc = 0;
        for i=1:256
            inc = inc + imghist1(1,i,layer);
            newxax1(1,i,layer) = (inc/(rows*cols))*256;
        end
        newxax1 = int64(newxax1);
        newimg = img;
    end
    
    invxax = 1:256;
    if rgb>1
        invxax(:,:,2) = 1:256;
        invxax(:,:,3) = 1:256;
    end

    for layer=1:rgb
        for i=1:256
            for j=1:256
                if newxax(1,i,layer) == newxax1(1,j,layer)
                    invxax(1,i,layer) = j;
                end
            end
        end
    end

    % for layer=1:rgb
    %     for i = 1:cols
    %         minval = abs(newxax(1,i,layer) - newxax1(1,1,layer));
    %         minj = 0;
    %         for j = 1:256
    %             if abs(newxax(1,i,layer) - newxax1(1,j,layer))<minval
    %                 minval = abs(newxax(1,i,layer) - newxax1(1,j,layer));
    %                 minj = j;
    %             end
    %         invhist(1,i,layer) = minj;
    %         end
    %     end
    % end
    
    for layer=1:rgb
        for c = 1:cols
            for r = 1:rows
                if img(r,c,layer) == 0
                    continue
                end
                newimg(r,c,layer) = invxax(1,img(r,c,layer),layer);
            end
        end
    end
end