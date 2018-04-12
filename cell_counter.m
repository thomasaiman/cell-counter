set(0,'defaultfigurecolormap',gray)
% Set filename
fname = 'bmd1.jpg';

% Load
IMG = imread(fname);
IMG3 = IMG(:,:,3);
IMG2 = IMG(:,:,2);
IMG1 = IMG(:,:,1);


nbox = 5;
IMGc = imclose(IMG3,strel('disk',nbox));

% IMGc = double(IMGc);
% % Normalize: [0,1]
% IMGn = (IMGc - min(IMGc(:))) ./ (max(IMGc(:)- min(IMGc(:))));
% % Otsu segmentation for myelin/non-myelin
%  myThresh = mean(IMG1(:));
% myThresh = graythresh(IMGn);
% myMask = IMGn < myThresh;
% % myMask = ~myMask;
IMGb = imbinarize(IMGc);
myMask = ~IMGb;
%myMask = repmat(myMask,[1,1,3]);
IMGt = IMG;
myThresh = mean(IMG1(~myMask));
IMGnofiber = IMG1;
IMGnofiber(myMask) = myThresh;


% figure(1); imshow(IMGnofiber)
% axis([150 300 150 300])
% title('red channel, no fibers')

IMGb = imbinarize(IMGnofiber);
% figure(2); imshow(IMGb)
% axis([150 300 150 300])
% title('red channel, no fibers, binarized')

IMGc = imclose(IMGb,strel('disk',1));
% figure(3); imshow(IMGc)
% axis([150 300 150 300])
% title('red channel, no fibers, binarized, closed')

% Identify connected regions in images and get statistics for these areas
mask2 = ~IMGc;
cc = bwconncomp(mask2, 8);
L = double(labelmatrix(cc));
R = regionprops(cc,'all');

IMG1(mask2) = 0;
IMG2(mask2) = 255;
IMG3(mask2) = 0;
IMGlabeled = cat(3, IMG1, IMG2, IMG3);
figure(4); imshow(IMGlabeled);
title(sprintf('number of inflammatory cells = %i', cc.NumObjects))

for ii = 1:length(R)
    loc = R(ii).Centroid;
    text(loc(1),loc(2),num2str(ii))
end