%%%%%% Segmentation based on Otsu's Method, Naidi Sun, 12/01/2025 %%%%%%
% Segmentation of vessel tree (semi-automatic);
% Uses Otsu's method for thresholding and determining vessel boundaries
 clc;
 clear all;
 close all;
 %%%%% load '_I2D','_SO2','_for speed'
%% Reset the resolution of I2D matrix: 2.5 um in both directions
%I2D = flipud(I2D);
%temp = I2D(:,1:24:end);
temp = I2D(:,1:18:end);
temp1 = zeros(size(temp,1)*4,size(temp,2));
for i = 1:4
    temp1(i:4:end,:) = temp; 
end
I2D = temp1;
% Pre Process of Data
I2D = log(I2D);
I2D = I2D/max(max(I2D));
I2D = mat2gray(I2D,[min(min(I2D)) 1]);
figure;imagesc(I2D);colormap hot
%%
% If first time, run this section, otherwise DO NOT run this section
DisplayLabels = zeros(size(I2D));
ActualLabels  = {};
count = 1;
Masks = {};
Two_Edge = {};
%% Main
reply='y';
while (reply == 'y')
    tempL = zeros(size(I2D));
    figure  
    imagesc(I2D);
    colormap hot
    axis square
    screenSize = get(0,'Screensize');
    set(gcf, 'Position', screenSize);
    pause    
    
    prof = getline;
    prof = round(prof);
    
    Two_Edge{2*count-1} = prof;
    line(prof(:,1),prof(:,2));
    pause    
    prof1 = getline;
    prof1 = round(prof1);
    Two_Edge{2*count} = prof1;    
    line(prof1(:,1),prof1(:,2));
    prof = [prof;prof1;prof(1,:)];
    
    mask2D=zeros(size(I2D));    
    for i=1:size(prof,1)-1
        mask2D = func_Drawline(mask2D, prof(i,2),prof(i,1),prof(i+1,2),prof(i+1,1), 1);
    end    
    mask2D      = imfill(mask2D,'holes');
    mask2D      = logical(mask2D);
    T           =   zeros(size(I2D));
    T(mask2D)   =   I2D(mask2D);
    ThreshParameter = 1.2;        %You can change ThreshParameter to change the segmentation result more smooth or more rough
    tt = graythresh(T) * ThreshParameter;
    T2 = T>tt;
    
    close all;
    % Display Labels again
    [L num] = bwlabeln(T2);
    LI = L;
    
    % Clean up the selected area, the following codes will take a long time
    LI = bwmorph(LI,'clean');
    LI = bwmorph(LI, 'fill');
    LI = bwmorph(LI, 'close',2);
    LI = imfill(LI,'holes');
    %LI = bwmorph(LI,'open');
    LI = bwareaopen(LI, 100);
    LI = bwmorph(LI,'spur',30);
    
    temp = LI;
    temp = imfill(temp,'hole');
    temp = bwmorph(temp,'open');
    temp = bwmorph(temp,'majority');
    temp = bwmorph(temp,'clean');
    temp = bwmorph(temp,'spur',50);
    temp = bwareaopen(temp,10);
    LI = temp;
    
    imagesc(imoverlay(I2D,logical(LI),[0,1,0]));
    %tttttttt = input('','s');
    reply = input('Was the segmentation result ok? Should it be saved? [y/n] ', 's');
    if (reply == 'y')
        DisplayLabels(logical(LI)) = count;
        ActualLabels{count} = find(T2); 
        Masks{count} = find(mask2D);
        FinishedActualLabels{count} = find(LI);
        count = count + 1;
    end  
  
    
    reply = input('Do you want more? y/n [y]: ', 's');
end
BifurLabel = zeros(size(I2D));
for i = 1 : length(FinishedActualLabels)
    BifurLabel(FinishedActualLabels{i}) = i;
end
figure;imagesc(BifurLabel);colormap jet;
%% Save 
newFilename = ['SO2Labels'];
save(newFilename, 'DisplayLabels', 'Masks', 'ActualLabels', 'count','Two_Edge');
newFilename = ['FinishedLabels'];
save(newFilename, 'FinishedActualLabels');
save(['BifurLabel_2.mat'], 'BifurLabel');