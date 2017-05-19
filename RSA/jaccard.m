%% Load data
clear all
close all

studyname=input('Enter study label: ','s');
% input('set background color 0-255')

[fn1, pn1]= uigetfile('*.jpg','Select the Study Images','MultiSelect','on');

imdir = [pn1];
imglist = dir([imdir '*jpg']);

drawfigureOn = 0;

%%

for i = 1:length(imglist)
    [A,MAP,ALPHA] = imread([imdir imglist(i).name]);
    imglist(i).im = A;
    imglist(i).alpha = double(ALPHA);
end


%% Process Image files
JnameList = [];

[Combos] = nchoosek(1:length(imglist),2);
jaccardMAT = NaN(length(imglist));

tic
for i=1:length(Combos)
    if size(squeeze(imglist(Combos(i,1)).im),3)>3
        im1 = squeeze(imglist(Combos(i,1)).im(:,:,4));
    else
        im1 = squeeze(mean(imglist(Combos(i,1)).im,3))/255;
    end
    
    if size(squeeze(imglist(Combos(i,2)).im),3)>3
        im2 = squeeze(imglist(Combos(i,2)).im(:,:,4));
    else
        im2 = squeeze(mean(imglist(Combos(i,2)).im,3))/255;
    end
    
    ImDiff = abs(double(im1) - double(im2));
    DifferentPix = sum(ImDiff(:)~=0);
    
    jaccardMAT(Combos(i,1),Combos(i,2)) = sum(DifferentPix)/sum(length(ImDiff(:)));
    jaccardMAT(Combos(i,2),Combos(i,1)) = sum(DifferentPix)/sum(length(ImDiff(:)));
    
    compnum = (Combos(i,1)-1)*length(imglist) + Combos(i,2);
    
    if drawfigureOn
        subplot(length(imglist),length(imglist),compnum)
        imagesc(ImDiff)
        axis off
        axis image
        drawnow;
        toc
    elseif i == 1 
        subplot(1,3,1)
        imagesc(im1)
        axis off
        axis image
 
        title('Images for first comparision')
        subplot(1,3,2)
        imagesc(ImDiff)
        axis off
        axis image
        
        subplot(1,3,3)
        imagesc(im2)
        axis off
        axis image
        toc

    end
    display(compnum)
    
end

figure(2)
imagesc(jaccardMAT)
axis square
axis off
title('Dissimilarity matrix for images')

% 
% imagelist = [];
% for i=1:48
%     imagelist(i).image = imread(sprintf('C:\\Users\\43873685\\Desktop\\LINA_MQ\\MACQUARIE\\Research Projects\\5_NumericalFormat\\1_Programming\\NumericalFormat_Quadrants\\StimulusImages\\%i.png',i));
% end
% showRDMs(struct('name','DSM','RDM',rand(48)),1,[],[],[],[],struct('images',imagelist))

%% save figures

dat_name = [studyname '_jaccard.mat'];
eval(['save ' dat_name ' imglist jaccardMAT'])