% MTI805 - Compréhension de l'image
% M'Hand Kedjar
% Runs only on linux 
clear all
close all
clc

% listH = [15011,16068,41029,41096,69000,87015,108036,134049,145059,175083,207038,217090,226033,247003,368037,384022];
% listV = [6046,64061,71076,104055,130014,140006,147077,159002,217013,223004,226043,267036,289011,326085,334025,372019];

tic
for choice = 0:0;
 % Fichiers de donn�es
 if choice == 0
        inImageFolder = 'testval';
        inFolder = strcat('data/images/',inImageFolder,'/');
        files = dir( fullfile(inFolder,'*.jpg') );
        listComp = zeros(1,numel(files));
        for k1 = 1 : numel(files)
            inImageFile = files(k1).name;
            outFile2 = strsplit(inImageFile,'.');
            outFile3 = str2double(outFile2{1});
            listComp(k1) = outFile3;
        end
 end   
end        
%     inFolder = strcat('data/images/',inImageFolder,'/');
%     files = dir( fullfile(inFolder,'*.jpg') );
% 

for k = 0 : 0
    
    if k == 0
       imFolder0 = 'testval';
       imFolder = 'testval/';
       listHV = listComp;
    end
  
    for i = 1 : numel(listHV)
        
        close all
        
        benchResults3 = zeros(13,9);
        
        
        inSegFile3 = strcat('data/segments/',imFolder,'seg__3__',num2str(listHV(i)),'.mat');
        
        inImgFile = strcat('data/images/',imFolder,num2str(listHV(i)),'.jpg');
        inGTFile  = strcat('data/groundtruth/',imFolder,num2str(listHV(i)),'.mat');
        
        img = imread(inImgFile);
        N = size(img , 1) * size(img , 2); % Nombre de pixels dans l'image    
        
       
        inFiles3 = load(inSegFile3);
        
        
        inFileAll3 = inFiles3.tbpResults3;     
 
       
        % Second LIST       
        for j = 1 : 13
            inFile3 = inFileAll3{j,4};
            running_time = inFileAll3{j,5};
            [ss,so] = evaluation_ev_image(inFile3, inGTFile, inImgFile);
            [thresh,cntR,sumR,cntP,sumP] = evaluation_bdry_image(inFile3,inGTFile);
            [sumCO] = evaluation_compactness_image(inFile3, inGTFile);
            [sumUE] = evaluation_undersegmentation_image(inFile3, inGTFile);
            
            benchResults3(j , 1) = inFileAll3{j,6};     % Nombre de superpixels
            benchResults3(j , 2) = cntR / sumR;         % Boundary Recall
            benchResults3(j , 3) = cntP / sumP;         % Precision
            benchResults3(j , 4) = ss / so;             % Explained Variation
            benchResults3(j , 5) = sumCO / N;           % Compactness
            benchResults3(j , 6) = mean(sumUE) / N;     % Mean Undersegmentation
            benchResults3(j , 7) = max(sumUE) / N;      % Max Undersegmentation
            benchResults3(j , 8) = min(sumUE) / N;      % Min Undersegmentation            
            benchResults3(j , 9) = running_time;        % Running time
           
%             level = sprintf('k:%d , i:%d , j:%d \n', k , i , j)
        end
        
        % Sauvegarder les résulats
        outDir3 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults3_.mat');
        
        outFig1_3 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults3_.png');
        outFig2_3 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_bdryprecResults3_.png');
        outFig3_3 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_runtimeResults3_.png');
       
        save(outDir3, 'benchResults3');
        
        figure(1), plot(benchResults3(:,1),benchResults3(:,2), 'rs-', 'LineWidth' , 2 );
        hold on        
        plot(benchResults3(:,1),benchResults3(:,4), 'g^-','LineWidth' , 2);
        plot(benchResults3(:,1),benchResults3(:,5), 'bo-','LineWidth' , 2);
        plot(benchResults3(:,1),benchResults3(:,6), 'k*-','LineWidth' , 2);
                        
        grid on
        fl1 = legend('Rappel des contours','Variation expliqu\''ee','Compacit\''e','Erreur de sous-segmentation','Location','best');
        set(fl1,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' modified gray image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        saveas(1, outFig1_3)
        
        figure(2), plot(benchResults3(:,3),benchResults3(:,2), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl2 = legend('Rappel des contours vs Pr\''ecision','Location','best');
        set(fl2,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' modified gray image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        
        xlabel('Pr\''ecision','Interpreter','Latex')
        ylabel('Rappel des contours','Interpreter','Latex')
        saveas(2, outFig2_3)
        
        figure(3), plot(benchResults3(:,1),benchResults3(:,9), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl3 = legend('Temps de calcul','Location','best');
        set(fl3,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' modified gray image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        ylabel('Temps de calcul (secondes)','Interpreter','Latex')
        saveas(3, outFig3_3)
        
        i
    end
end

toc
