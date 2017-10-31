% Runs only on linux 
clear all
close all
clc

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
% benchResults1(j , 1) = inFileAll1{j,6};      % Nombre de superpixels
%             benchResults1(j , 2) = cntR / sumR;         % Boundary Recall
%             benchResults1(j , 3) = cntP / sumP;         % Precision
%             benchResults1(j , 4) = ss / so;             % Explained Variation
%             benchResults1(j , 5) = sumCO / N;           % Compactness
%             benchResults1(j , 6) = mean(sumUE) / N;     % Mean Undersegmentation
%             benchResults1(j , 7) = max(sumUE) / N;      % Max Undersegmentation
%             benchResults1(j , 8) = min(sumUE) / N;      % Min Undersegmentation            
%             benchResults1(j , 9) = running_time;        % Running time
% 



for k = 0 : 0
    
    if k == 0
       imFolder0 = 'testval';
       imFolder = 'testval/';
       listHV = listComp;
    end
  
    rc = zeros(13,numel(listHV));  
    ev = zeros(13,numel(listHV));  
    co = zeros(13,numel(listHV));  
    ue = zeros(13,numel(listHV));  
    rt = zeros(13,numel(listHV)) ;
    
    
    for i = 1 : numel(listHV)        
        close all       
        
        inResults1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults_.mat'); %
        inResults3 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResults3_.mat'); % 
        
        outFig1_1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_benchResultsCompar_3.png');       
        outFig3_1 = strcat('data/segments/',imFolder,num2str(listHV(i)),'_runtimeResultsCompar_3.png');
        
        inR1 = load(inResults1);
        inR3 = load(inResults3); 
        
        inr1 = inR1.benchResults;
        inr3 = inR3.benchResults3;
        
        rc(:,i) = inr3(:,2) - inr1(:,2);
        ev(:,i) = inr3(:,4) - inr1(:,4);
        co(:,i) = inr3(:,5) - inr1(:,5);
        ue(:,i) = inr3(:,6) - inr1(:,6);
        rt(:,i) =  inr3(:,9) - inr1(:,9);
        
        figure(1),plot(inr1(:,1) , inr3(:,2) - inr1(:,2),'rs-', 'LineWidth' , 2)
        hold on
        plot(inr1(:,1) , inr3(:,4) - inr1(:,4),'g^-','LineWidth' , 2)
        plot(inr1(:,1) , inr3(:,5) - inr1(:,5), 'bo-','LineWidth' , 2)
        plot(inr1(:,1) , inr3(:,6) - inr1(:,6), 'k*-','LineWidth' , 2)
        
        grid on
        fl1 = legend('Rappel des contours','Variation expliqu\''ee','Compacit\''e','Erreur de sous-segmentation','Location','best');
        set(fl1,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 - Avec pr\''etraitement gray- image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        
        saveas(1, outFig1_1)
        
        grid on
        figure(3), plot(inr1(:,1) , inr3(:,9) - inr1(:,9), 'c+-','LineWidth' , 2)
        grid on
        fl3 = legend('Temps de calcul','Location','best');
        set(fl3,'Interpreter','Latex');
        title(strcat('Performance des TurboPixels pour BSDS500 - Avec pr\''etraitement gray - image: ',num2str(listHV(i)),'.jpg'),'Interpreter','Latex')
        xlabel('Nombre de superpixels','Interpreter','Latex')
        ylabel('Temps de calcul (secondes)','Interpreter','Latex')
        saveas(3, outFig3_1)
        
        
    end
end

toc
