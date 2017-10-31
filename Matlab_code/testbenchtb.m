% MTI805 - Compréhension de l'image
% M'Hand Kedjar
% Runs only on linux 
clear all
close all
clc

% listH = [15011,16068,41029,41096,69000,87015,108036,134049,145059,175083,207038,217090,226033,247003,368037,384022];
% listV = [6046,64061,71076,104055,130014,140006,147077,159002,217013,223004,226043,267036,289011,326085,334025,372019];

tic
for choice = 1:3;
 % Fichiers de donn�es
    if choice == 1
        inImageFolder = 'train';
        inFolder = strcat('data/images/',inImageFolder,'/');
        files = dir( fullfile(inFolder,'*.jpg') );
        listTrain = zeros(1,numel(files));
        for k1 = 1 : numel(files)
            inImageFile = files(k1).name;
            outFile2 = strsplit(inImageFile,'.');
            outFile3 = str2double(outFile2{1});
            listTrain(k1) = outFile3;
        end
    end
    if choice == 2
        inImageFolder = 'val';
        inFolder = strcat('data/images/',inImageFolder,'/');
        files = dir( fullfile(inFolder,'*.jpg') );
        listVal = zeros(1,numel(files));
        for k1 = 1 : numel(files)
            inImageFile = files(k1).name;
            outFile2 = strsplit(inImageFile,'.');
            outFile3 = str2double(outFile2{1});
            listVal(k1) = outFile3;
        end
    end
    if choice ==3
        inImageFolder = 'test';
        inFolder = strcat('data/images/',inImageFolder,'/');
        files = dir( fullfile(inFolder,'*.jpg') );
        listTest = zeros(1,numel(files));
       for k1 = 1 : numel(files)
            inImageFile = files(k1).name;
            outFile2 = strsplit(inImageFile,'.');
            outFile3 = str2double(outFile2{1});
            listTest(k1) = outFile3;
        end
    end
end        
%     inFolder = strcat('data/images/',inImageFolder,'/');
%     files = dir( fullfile(inFolder,'*.jpg') );
% 

for k = 1 : 3
    
    if k == 1
        imFolder0 = 'train';
       imFolder = 'train/';
       listHV = listTrain;
    end
    
    if k == 2
        imFolder0 = 'val'
       imFolder = 'val/';
       listHV = listVal;
    end

    if k == 3  
        imFolder0 = 'test';
        imFolder = 'test/'
        listHV = listTest;
    end
    
    for i = 17 : numel(listHV)
        
        close all
        benchResults = zeros(12,9); % Matrice qui va contenir les mesures de performances
        
        inSegFile = strcat('data/segments/',imFolder,'seg_',num2str(listHV(i)),'.mat'); %
        inImgFile = strcat('data/images/',imFolder,num2str(listHV(i)),'.jpg');
        inGTFile  = strcat('data/groundtruth/',imFolder,num2str(listHV(i)),'.mat');
        
        img = imread(inImgFile);
        N = size(img , 1) * size(img , 2); % Nombre de pixels dans l'image    
        
        inFiles = load(inSegFile);
        inFileAll = inFiles.tbpResults;
        
        for j = 1 : 13
            inFile = inFileAll{j,4};
            running_time = inFileAll{j,5};
            [ss,so] = evaluation_ev_image(inFile, inGTFile, inImgFile);
            [thresh,cntR,sumR,cntP,sumP] = evaluation_bdry_image(inFile,inGTFile);
            [sumCO] = evaluation_compactness_image(inFile, inGTFile);
            [sumUE] = evaluation_undersegmentation_image(inFile, inGTFile);
            
            benchResults(j , 1) = inFileAll{j,6};      % Nombre de superpixels
            benchResults(j , 2) = cntR / sumR;         % Boundary Recall
            benchResults(j , 3) = cntP / sumP;         % Precision
            benchResults(j , 4) = ss / so;             % Explained Variation
            benchResults(j , 5) = sumCO / N;           % Compactness
            benchResults(j , 6) = mean(sumUE) / N;     % Mean Undersegmentation
            benchResults(j , 7) = max(sumUE) / N;      % Max Undersegmentation
            benchResults(j , 8) = min(sumUE) / N;      % Min Undersegmentation            
            benchResults(j , 9) = running_time;        % Running time
           
%             level = sprintf('k:%d , i:%d , j:%d \n', k , i , j)
        end
        
        % Sauvegarder les résulats
        outDir = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults_.mat');
        outFig1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults_.png');
        outFig2 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_bdryprecResults_.png');
        outFig3 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_runtimeResults_.png');
       
        save(outDir, 'benchResults');
        
        figure(1), plot(benchResults(:,1),benchResults(:,2), 'rs-', 'LineWidth' , 2 );
        hold on        
        plot(benchResults(:,1),benchResults(:,4), 'g^-','LineWidth' , 2);
        plot(benchResults(:,1),benchResults(:,5), 'bo-','LineWidth' , 2);
        plot(benchResults(:,1),benchResults(:,6), 'k*-','LineWidth' , 2);
                        
        grid on
        fl1 = legend('Rappel des contours','Variation expliqu\''ee','Compacit\''e','Erreur de sous-segmentation','Location','best');
        set(fl1,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        saveas(1, outFig1)
        
        figure(2), plot(benchResults(:,3),benchResults(:,2), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl2 = legend('Rappel des contours vs Pr\''ecision','Location','best');
        set(fl2,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        
        xlabel('Pr\''ecision','Interpreter','Latex')
        ylabel('Rappel des contours','Interpreter','Latex')
        saveas(2, outFig2)
        
        figure(3), plot(benchResults(:,1),benchResults(:,9), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl3 = legend('Temps de calcul','Location','best');
        set(fl3,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        ylabel('Temps de calcul (secondes)','Interpreter','Latex')
        saveas(3, outFig3)
       
    end
end

toc
