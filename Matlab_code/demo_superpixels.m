% Runs only on Windows 64
% Runs the superpixel code 
clc,clear all, close all
addpath('lsmlib');

img = im2double(imread('lizard.jpg'));
figure, imshow(img);
se = strel('disk',5);
afterOpening = imopen(img,se); 
figure, imshow(afterOpening,[]);



for choice = 0:0;
    % Fichiers de données
    
    if choice == 0
         inImageFolder = 'comparaison';
    end
    
    if choice == 1
         inImageFolder = 'all';
    end
    if choice == 2
        inImageFolder = 'train';
    end
    if choice == 3
        inImageFolder = 'val';
    end
    if choice == 4
        inImageFolder = 'test';
    end
        
    inFolder = strcat('data\images\',inImageFolder,'\');
    files = dir( fullfile(inFolder,'*.jpg') );
    
    spRange = [25,50,100,200:200:2000];
    
    for k = 1 : numel(files)
        
        inImageFile = files(k).name;
        inImage = strcat('data\images\',inImageFolder,'\',inImageFile);
        
        img = im2double(imread(inImage));
        % Cellule pour sauvegarder les resulats
        tbpResults = cell(numel(spRange),6);
        outFile1 = strsplit(inImage,'\');
        outFile2 = strsplit(outFile1{4},'.');
        outFile3 = strcat(outFile2{1},'.mat');
        outDir = strcat('data\segments\',inImageFolder,'\','seg_',outFile3);
        
        for n = 1:numel(spRange)
            close all
            numSuperpixels = spRange(n);
            % Algorithme TurboPixels
            tic
            [phi,boundary,disp_img,sup_img] = superpixels2(img, numSuperpixels);
            runnning_time = toc;
            tbpResults{n , 1} = phi;
            tbpResults{n , 2} = boundary;
            tbpResults{n , 3} = disp_img;
            tbpResults{n , 4} = sup_img;
            tbpResults{n , 5} = runnning_time;
            tbpResults{n , 6} = numSuperpixels;
            outFig = strcat('data\segments\',inImageFolder,'\','seg_',num2str(numSuperpixels),'_',outFile2{1},'.png');
            figure(1),imagesc(disp_img);
            title(sprintf('TurboPixels N_{sp} = %s [ BSDS500 %s image: %s.jpg ]',num2str(numSuperpixels),inImageFolder, outFile2{1}))
            saveas(1, outFig)
        end        
        save(outDir,'tbpResults')
    end

end
