function [sumCO] = evaluation_compactness_image(inFile, gtFile)
% function [sumCO] = evaluation_compactness_image(inFile, gtFile, evFile6)
%
% Calculate Compactness for superpixel segmentations as proposed in [2].
%
%   [5] A. Schick, M. Fischer, R. Stiefelhagen.
%       Measuring and evaluating the compactness of superpixels.
%       Proceedings of the International Conference on Pattern Recognition, pages 930–934, 2012.
%
% INPUT
%	inFile:     a collection of segmentations in a cell 'segs' stored in a mat file
%               - note that using an ultrametric contour map is not possible
%               with this evaluation function.
%	gtFile:     file containing a cell of ground truth segmentations
%   evFile6:    temporary output for this image
%
% OUTPUT
%	sumCO:      sum of compactness measure; needs to be divided by the
%                number of total pixels
%
% David Stutz <david.stutz@rwth-aachen.de>

    segs = cell(1,1);
    segs{1,1} = inFile;

    % Only run if we have the correct format - does not work on ucm
    if exist('segs', 'var')

        load(gtFile);
        nSegs = numel(groundTruth);
        if nSegs == 0,
            error(' bad gtFile !');
        end

        seg = double(segs{1});
        nLabels = max(max(seg));
        N = size(seg, 1)*size(seg, 2);
        
        for m = 1: nLabels
            segLabelM = (seg == m);
            prop = bwconncomp(segLabelM, 4);
            
            for k = 1: prop.NumObjects
                if k > 1
                    nLabels = nLabels + 1;
                    for i = 1: size(prop.PixelIdxList{k}, 1)
                        seg(prop.PixelIdxList{k}(i)) = nLabels;
                    end;
                end;
            end;
        end;
        
        for m = 1: nLabels
            segLabelM = (seg == m);
            prop = bwconncomp(segLabelM, 4);
            
            if prop.NumObjects > 1
                error('Non-connected superpixel detected!');
            end;
        end;
        
        sumCO = 0;
       
        for m = 1: nLabels
            % segLabelM is zero everywhere except where it was labeled m.
            segLabelM = (seg == m);

            if sum(sum(segLabelM)) > 0
                properties = regionprops(segLabelM, 'Area', 'Perimeter');
                %imshow(segLabelM);
                
                if properties.Perimeter > 0
                    sumCO = sumCO + properties.Area*((4*pi*properties.Area)/(properties.Perimeter*properties.Perimeter));
                    
                end;
            end;
        end;
    end;
end