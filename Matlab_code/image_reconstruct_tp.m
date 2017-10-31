
close all, clc, clear all
a = load('data/segments/v/seg_372019.mat'); % Charger les résultats de la ségmentation par turbopixels
a = a.tbpResults; % Accès à la structure
img =  imread('data/images/v/372019.jpg'); % Charger l'image correspondante
img = im2double(img);

subplot(1,2,1),imagesc(img);
title(sprintf('Image originale'),'FontSize', 16,'Interpreter','Latex');

for j = 1:size(a,1)
    
segments = a{j,4};       % Charger les segments
nsp = a{j,6}; % Nombre de superpixels

img_reconstructed = zeros(size(img,1),size(img,2), size(img,3));
img_reconstructed_r = zeros(size(img,1),size(img,2));
img_reconstructed_g = zeros(size(img,1),size(img,2));
img_reconstructed_b = zeros(size(img,1),size(img,2));

img_r = img(:,:,1);
img_g = img(:,:,2);
img_b = img(:,:,3);

    for i = 1:max(segments(:))
        ind = find(segments == i);
        img_reconstructed_r(ind) = mean(img_r(ind));
        img_reconstructed_g(ind) = mean(img_g(ind));
        img_reconstructed_b(ind) = mean(img_b(ind));
    end


img_reconstructed(:,:,1) = img_reconstructed_r;
img_reconstructed(:,:,2) = img_reconstructed_g;
img_reconstructed(:,:,3) = img_reconstructed_b;


subplot(1,2,2),imagesc(img_reconstructed);
title(sprintf('Reconstruction de l\''image: %d superpixels',nsp), 'FontSize', 16,'Interpreter','Latex');
% if(j==1)
%     pause()
% end
% if(j~=1)
%     pause()
% end
end

