function imgout = raidsegmentation(imgin, imgoriginal)
    linelength = 1;
    se0 = strel('line', linelength, 0);
    se45 = strel('line', linelength, 45);
    se90 = strel('line', linelength, 90);
    se135 = strel('line', linelength, 135);
    dilated = imdilate(imgin, [se135 se90 se45 se0]);
    dilated = imclearborder(dilated,4);
    imgout = imfill(dilated, 'holes');
    imgout = bsxfun(@times, imgoriginal, cast(imgout, 'like', imgoriginal));
end