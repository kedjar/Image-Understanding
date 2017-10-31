
% Runs only on Windows 64
% Runs the superpixel code 
clc,clear all, close all
addpath('lsmlib');

for choice = 0:0;
    % Fichiers de données
    
    if choice == 0
         inImageFolder = 'testval';
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
        
        img1 = im2double(imread(inImage));
        se = strel('disk',5);
        img_tmp = rgb2gray(img1);
        img2 = imopen(img_tmp,se);     
              
        
        % Cellule pour sauvegarder les resulats
        %tbpResults1 = cell(numel(spRange),6);
        tbpResults3 = cell(numel(spRange),6);
        
        outFile1 = strsplit(inImage,'\');
        outFile2 = strsplit(outFile1{4},'.');
        outFile3 = strcat(outFile2{1},'.mat');
        
       % outDir1 = strcat('data\segments\',inImageFolder,'\','seg__1__',outFile3);
        outDir2 = strcat('data\segments\',inImageFolder,'\','seg__3__',outFile3);
       
        for n = 1:numel(spRange)
            close all
            numSuperpixels = spRange(n);
            % Algorithme TurboPixels
%             tic
%             [phi,boundary,disp_img,sup_img] = superpixels2(img1, numSuperpixels);
%             runnning_time = toc;
%             
%             tbpResults1{n , 1} = phi;
%             tbpResults1{n , 2} = boundary;
%             tbpResults1{n , 3} = disp_img;
%             tbpResults1{n , 4} = sup_img;
%             tbpResults1{n , 5} = runnning_time;
%             tbpResults1{n , 6} = numSuperpixels;
%             outFig1 = strcat('data\segments\',inImageFolder,'\','seg_',num2str(numSuperpixels),'_',outFile2{1},'__1__.png');
%             figure(1),imagesc(disp_img);
%             title(sprintf('TurboPixels N_{sp} = %s [ BSDS500 %s image: %s.jpg ]',num2str(numSuperpixels),inImageFolder, outFile2{1}))
%             saveas(1, outFig1)
            
            tic
            [phi,boundary,disp_img,sup_img] = superpixels2(img2, numSuperpixels);
            runnning_time = toc;
            
            tbpResults3{n , 1} = phi;
            tbpResults3{n , 2} = boundary;
            tbpResults3{n , 3} = disp_img;
            tbpResults3{n , 4} = sup_img;
            tbpResults3{n , 5} = runnning_time;
            tbpResults3{n , 6} = numSuperpixels;
            outFig2 = strcat('data\segments\',inImageFolder,'\','seg_',num2str(numSuperpixels),'_',outFile2{1},'__3__.png');
            figure(2),imagesc(disp_img);
            title(sprintf('TurboPixels N_{sp} = %s [ BSDS500 %s modified gray image: %s.jpg ]',num2str(numSuperpixels),inImageFolder, outFile2{1}))
            saveas(2, outFig2)            
        end        
       % save(outDir1,'tbpResults1')
        save(outDir2,'tbpResults3')
    end

end
