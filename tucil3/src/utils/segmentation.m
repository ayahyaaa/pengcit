function imgout = segmentation(imgin, imgoriginal, method)
    % Image Segmentation memanfaatkan hasil dari edge detection
    % referensi dari mathworks pada https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html
    % tested all tapi image dependent
    % TODO generalize image
    linelength = 3;
    diskradius = 3;
    if strcmp(method,'laplace') || strcmp(method,'log')
        linelength = 7;
        diskradius = 4;
    elseif strcmp(method, 'roberts')
        linelength = 6;
    % elseif strcmp(method, 'canny')
    %     linelength = 1;
    %     diskradius = 1;
    end
    imgin = imbinarize(imgin);
    imgsize = size(imgoriginal);
    edgesize = size(imgin);
    if (imgsize(1)~=edgesize(1) && imgsize(2)~=edgesize(2))
        imgin = imgin(1:imgsize(1),1:imgsize(2));
    end
    dilated = imclearborder(imgin);
    
    se0 = strel('line', linelength, 0);
    se45 = strel('line', linelength, 45);
    se90 = strel('line', linelength, 90);
    se135 = strel('line', linelength, 135);
    seD = strel('disk', diskradius);
    dilated = bwmorph(dilated, 'bridge');
    dilated = imclose(dilated, seD);
    dilated = imdilate(dilated, [se135 se90 se45 se0]);
    bordercleared = imclearborder(dilated,4);
    filled = imfill(bordercleared, 'holes');
    filled = bwareaopen(filled, 4000, 8);
    eroded = imerode(filled,seD);
    % figure; imshow(imgin);
    % figure; imshow(dilated);
    % figure; imshow(bordercleared);
    % figure; imshow(filled);
    % figure; imshow(eroded);
    
    
    imgout = bsxfun(@times, imgoriginal, cast(filled, 'like', imgoriginal));
end
