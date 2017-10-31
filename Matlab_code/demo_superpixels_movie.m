clear all
clc
close all

run1=1;
run2=1;

if(run1==1)
% Runs the superpixel code on the lizard image
tic
contour_color = [0,0,0];
save contour_color contour_color
addpath('lsmlib');
%img = im2double(imread('C:\matlab\workplace\data\BSR\BSDS500\data\images'+...
%'\test\103078 v-w2er35f4 à1292bvnm,7u ji-^mn;BVC. mg.jpg'));
img = im2double(imread('data\100075.jpg'));
%img = im2double(imread('C:\matlab\workplace\data\118020s.jpg'));

[phi,boundary,disp_img,frames] = superpixels(img, 200,1,contour_color);
save disp_img disp_img
save boundary boundary
save phi phi
imagesc(disp_img);
toc
end


if (run2==1)
load frames
load disp_img
N = size(frames,2);
load disp_img_initial_seed

imagesc(img)
title(sprintf('TurboPixels :: image originale'))
pause()
imagesc(disp_img_initial_seed)
title(sprintf('TurboPixels :: étape initiale'))
pause(2)
M(1) = getframe(gcf);
for i = 1 : N
    a = frames(1,i).cdata;
    imagesc(a);
    title(sprintf('TurboPixels :: itération %i',i));
    pause(0.8)
    M(i+1) = getframe(gcf);    
end
pause(0.9)
imagesc(disp_img)
title(sprintf('TurboPixels :: résultat final'))

% M(N+2) = getframe(gcf);
% 
% movie2avi(M, 'TurboPixelsAnimation2.avi', 'compression', 'None');
end


% img_groundtruth=load('C:\matlab\workplace\data\BSR\BSDS500\data\groundTruth\train\12003.mat');
% img_1=img_groundtruth.groundTruth;
% for i = 1:5
%     a = img_1{i};
%     a_s=a.Segmentation;
%     
%     a_b=a.Boundaries;
%     figure,imagesc(a_s)
%     figure,imagesc(a_b)
%     pause()
% end

