function imgout = segmentation(imgin, imgoriginal)
    % Image Segmentation memanfaatkan hasil dari edge detection
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
