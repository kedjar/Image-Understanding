clc,clear all, close all
addpath('lsmlib');
inFolder = 'all\';
inFile = '68077';
inImgExt = '.jpg';
inGtExt = '.mat';

gt = load(strcat('data\groundtruth\',inFolder,inFile,inGtExt));
gt = gt.groundTruth;
img = imread(strcat('data\images\',inFolder,inFile,inImgExt));
img = im2double(img);
%img = im2double(imread(inImage));

[phi,boundary,disp_img,sup_img] = superpixels2(img, 100);

figure(1),imagesc(img)
figure(2),imagesc(disp_img);
figure(3),imagesc(sup_img);

for i = 1:numel(gt)
close all
as = gt{1,i};
as = as.Segmentation;
figure(i+3),imagesc(as)

%ass = im2double(as);%255*im2uint8(as/max(as(:)));
%rgbImage = cat(3, ass, ass, ass);
aa = display_logical(im2double(as), boundary, [0,0,0]);
figure, imagesc(aa)
bb = double(rgb2gray(aa));
% 
% bb1 =  bb(find(bb==0));
% bb(bb1) = 255;
cc = bb(find(bb>0));
dd = min(bb(cc));
bb(bb == dd) = 255;
%imshow(bb)
%imagesc(bb)
figure, imshow(bb/max(bb(:)))
clc
end