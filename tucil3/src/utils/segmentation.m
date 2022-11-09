function imgout = segmentation(imgin, imgoriginal)
    % Image Segmentation memanfaatkan hasil dari edge detection
    % referensi dari mathworks pada https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html
    % Baru tested ke canny
    % TODO test dan modifikasi buat edge detection lain
    se90 = strel('line', 4, 90);
    se0 = strel('line', 4, 0);
    seD = strel('diamond',1);
    dilated = imdilate(imgin,[se90 se0]);
    filled = imfill(dilated,'holes');
    segmented = imclearborder(filled,4);
    smoothed = imerode(segmented,seD);
    smoothed = imerode(smoothed,seD);
    
    imgout = bsxfun(@times, imgoriginal, cast(smoothed, 'like', imgoriginal));
end
