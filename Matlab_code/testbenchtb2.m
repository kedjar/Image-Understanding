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
        inImageFolder = 'comparaison';
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
       imFolder0 = 'comparaison';
       imFolder = 'comparaison/';
       listHV = listComp;
    end
  
    for i = 1 : numel(listHV)
        
        close all
        benchResults1 = zeros(13,9); % Matrice qui va contenir les mesures de performances
        benchResults2 = zeros(13,9);
        
        inSegFile1 = strcat('data/segments/',imFolder,'seg__1__',num2str(listHV(i)),'.mat'); %
        inSegFile2 = strcat('data/segments/',imFolder,'seg__2__',num2str(listHV(i)),'.mat');
        
        inImgFile = strcat('data/images/',imFolder,num2str(listHV(i)),'.jpg');
        inGTFile  = strcat('data/groundtruth/',imFolder,num2str(listHV(i)),'.mat');
        
        img = imread(inImgFile);
        N = size(img , 1) * size(img , 2); % Nombre de pixels dans l'image    
        
        inFiles1 = load(inSegFile1);
        inFiles2 = load(inSegFile2);
        
        inFileAll1 = inFiles1.tbpResults1;
        inFileAll2 = inFiles2.tbpResults2;
        
  % FiRST LIST       
        for j = 1 : 13
            inFile1 = inFileAll1{j,4};
            running_time = inFileAll1{j,5};
            [ss,so] = evaluation_ev_image(inFile1, inGTFile, inImgFile);
            [thresh,cntR,sumR,cntP,sumP] = evaluation_bdry_image(inFile1,inGTFile);
            [sumCO] = evaluation_compactness_image(inFile1, inGTFile);
            [sumUE] = evaluation_undersegmentation_image(inFile1, inGTFile);
            
            benchResults1(j , 1) = inFileAll1{j,6};      % Nombre de superpixels
            benchResults1(j , 2) = cntR / sumR;         % Boundary Recall
            benchResults1(j , 3) = cntP / sumP;         % Precision
            benchResults1(j , 4) = ss / so;             % Explained Variation
            benchResults1(j , 5) = sumCO / N;           % Compactness
            benchResults1(j , 6) = mean(sumUE) / N;     % Mean Undersegmentation
            benchResults1(j , 7) = max(sumUE) / N;      % Max Undersegmentation
            benchResults1(j , 8) = min(sumUE) / N;      % Min Undersegmentation            
            benchResults1(j , 9) = running_time;        % Running time
           
%             level = sprintf('k:%d , i:%d , j:%d \n', k , i , j)
        end
        
        % Sauvegarder les résulats
        outDir1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults1_.mat');
         
        outFig1_1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults1_.png');
        outFig2_1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_bdryprecResults1_.png');
        outFig3_1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_runtimeResults1_.png');
       
        save(outDir1, 'benchResults1');
        
        figure(1), plot(benchResults1(:,1),benchResults1(:,2), 'rs-', 'LineWidth' , 2 );
        hold on        
        plot(benchResults1(:,1),benchResults1(:,4), 'g^-','LineWidth' , 2);
        plot(benchResults1(:,1),benchResults1(:,5), 'bo-','LineWidth' , 2);
        plot(benchResults1(:,1),benchResults1(:,6), 'k*-','LineWidth' , 2);
                        
        grid on
        fl1 = legend('Rappel des contours','Variation expliqu\''ee','Compacit\''e','Erreur de sous-segmentation','Location','best');
        set(fl1,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' original image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        saveas(1, outFig1_1)
        
        figure(2), plot(benchResults1(:,3),benchResults1(:,2), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl2 = legend('Rappel des contours vs Pr\''ecision','Location','best');
        set(fl2,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' original image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        
        xlabel('Pr\''ecision','Interpreter','Latex')
        ylabel('Rappel des contours','Interpreter','Latex')
        saveas(2, outFig2_1)
        
        figure(3), plot(benchResults1(:,1),benchResults1(:,9), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl3 = legend('Temps de calcul','Location','best');
        set(fl3,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' original image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        ylabel('Temps de calcul (secondes)','Interpreter','Latex')
        saveas(3, outFig3_1)
        
       close all
       
        % Second LIST       
        for j = 1 : 13
            inFile2 = inFileAll2{j,4};
            running_time = inFileAll2{j,5};
            [ss,so] = evaluation_ev_image(inFile2, inGTFile, inImgFile);
            [thresh,cntR,sumR,cntP,sumP] = evaluation_bdry_image(inFile2,inGTFile);
            [sumCO] = evaluation_compactness_image(inFile2, inGTFile);
            [sumUE] = evaluation_undersegmentation_image(inFile2, inGTFile);
            
            benchResults2(j , 1) = inFileAll2{j,6};      % Nombre de superpixels
            benchResults2(j , 2) = cntR / sumR;         % Boundary Recall
            benchResults2(j , 3) = cntP / sumP;         % Precision
            benchResults2(j , 4) = ss / so;             % Explained Variation
            benchResults2(j , 5) = sumCO / N;           % Compactness
            benchResults2(j , 6) = mean(sumUE) / N;     % Mean Undersegmentation
            benchResults2(j , 7) = max(sumUE) / N;      % Max Undersegmentation
            benchResults2(j , 8) = min(sumUE) / N;      % Min Undersegmentation            
            benchResults2(j , 9) = running_time;        % Running time
           
%             level = sprintf('k:%d , i:%d , j:%d \n', k , i , j)
        end
        
        % Sauvegarder les résulats
        outDir2 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults2_.mat');
        
        outFig1_2 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults2_.png');
        outFig2_2 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_bdryprecResults2_.png');
        outFig3_2 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_runtimeResults2_.png');
       
        save(outDir2, 'benchResults2');
        
        figure(1), plot(benchResults2(:,1),benchResults2(:,2), 'rs-', 'LineWidth' , 2 );
        hold on        
        plot(benchResults2(:,1),benchResults2(:,4), 'g^-','LineWidth' , 2);
        plot(benchResults2(:,1),benchResults2(:,5), 'bo-','LineWidth' , 2);
        plot(benchResults2(:,1),benchResults2(:,6), 'k*-','LineWidth' , 2);
                        
        grid on
        fl1 = legend('Rappel des contours','Variation expliqu\''ee','Compacit\''e','Erreur de sous-segmentation','Location','best');
        set(fl1,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' modified image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        saveas(1, outFig1_2)
        
        figure(2), plot(benchResults2(:,3),benchResults2(:,2), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl2 = legend('Rappel des contours vs Pr\''ecision','Location','best');
        set(fl2,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' modified image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        
        xlabel('Pr\''ecision','Interpreter','Latex')
        ylabel('Rappel des contours','Interpreter','Latex')
        saveas(2, outFig2_2)
        
        figure(3), plot(benchResults2(:,1),benchResults2(:,9), 'rs-', 'LineWidth' , 2);
        
        grid on
        fl3 = legend('Temps de calcul','Location','best');
        set(fl3,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 -',imFolder0,' modified image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        ylabel('Temps de calcul (secondes)','Interpreter','Latex')
        saveas(3, outFig3_2)
        
        i
    end
end

toc
