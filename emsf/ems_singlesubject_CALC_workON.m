% function [trl,msf,A,B,times] = ems_singlesubject_CALC_workON(sub, cond_1,cond_2)
%
%
sub = 's02';
cond_1 ='data_left_arrow';                         
cond_2 ='data_rigth_arrow';


%% paths and choices
addpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/emsf')
% Here you have to add the path recursively, to get all the folders inside
addpath(genpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/fieldtrip_testedversion'))
addpath('/neurospin/local/matlab/R2015a/toolbox/matlab/datafun') 
% I'm also adding this path to make sure that basic matlab functions, such
% as min, max, etc, are taken from Matlab and not from FieldTrip. Because
% FieldTrip has a horrible habit of assigning the same name that Matlab
% does for some of each functions. 

% Directory
dirdata = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/bst2ft_data-todelete_downsampled/';


%% load two condtions 
load([dirdata sub '/data.mat'],cond_1,cond_2);

cond1 = eval(cond_1);                  % e.g. [225x306x176 double]
A = cond1.trial;
cond2 = eval(cond_2);                  % e.g. [225x306x176 double]
B = cond2.trial;

Time = cond1.time;
IndxChtmp = cond1.label;

%% Concatenate the two conditions in the trials dimension
AB=cat(1,A,B);

%%  from [nTrials x nSensors x nTimePoints] to [nSensors X nTimePoints X nTrials]
DATA = permute(AB,[2,3,1]);

conds = [logical([ones(length(A(:,1,1)),1); zeros(length(B(:,1,1)),1)]),...
    logical([zeros(length(A(:,1,1)),1); ones(length(B(:,1,1)),1)])] ;

%% Z-score each sensor separetely
DATAZ(1:3:306,:,:) = zscore(DATA(1:3:306,:,:)); % Grad 1
DATAZ(2:3:306,:,:) = zscore(DATA(2:3:306,:,:)); % Grad 1
DATAZ(3:3:306,:,:) = zscore(DATA(3:3:306,:,:)); % Grad 1

%% [trl,msf] = ems_2cond_diff(DATA,conds,grpInd,[noiseCov])
% trl : a set of surrogate trials, nTrials X nTimePoints
% msf : a set of spatial filters, nSensors X nTimePoints
[trl,msf] = ems_2cond_diff(DATAZ,conds,[]);

%% plots
% Define plot parameters
lineWidth = 3
% average surrogate time series for the two conditions
A = trl((conds(:,1)==1),:);
B = trl((conds(:,1)==0),:);
A = mean(A);
B = mean(B);
% plot condition A and B
% figure(1)
% plot(A, 'b')
% hold on
% plot(B, 'r')
% plot condition A - B

% Set figure size
close all
hFig = figure(1)
plot(Time, A-B, 'LineWidth', 3)
set(gcf, 'Color', 'white');
xlabel('Time (sec.)')
xlim([min(Time) max(Time)])
ylabel('Amplitude (z)')
hold on
y=get(gca,'ylim');
plot([0 0 ],y, 'k-');
title(['EMS - '  cond_1 ' vs. ' cond_2], 'Interpreter', 'none')

save2pdf([dirdata sub '/' 'EMS_'  cond_1 '_' cond_2 '.pdf'], gcf, 600)

% plot topography
    % original sampling rate: 1000Hz
    % now downsampled to 250Hz
    % epoched from -200 to +500 (0 = stim onset)
    
    % This was the critical part    
sensInd = {(1:3:306) (2:3:306) (3:3:306)}; % This is how you should specify the sensor Identity
ems_topo_explore(1,msf,@topoplot_wrapper_fieldtrip,{},[250 0.2],sensInd)
 

% %% [decision, true value] = ems_2cond_decode(DATA,conds,grpInd,[error_metric])
% [decision, tgt] = ems_2cond_decode(DATA,conds,[],2);
% for t=1:276
%     % count number of correct decision and do percentage
%     A = sum(decision(:,t) == tgt)/length(decision(:,1))*100;
%     DecTime(t) = A;
% end
% figure(3)
% plot(DecTime)
%  
% %%  D = ems_permute(nIters,trl,conds,objFun,varargin)
% % iterations x time
% D = ems_permute(100,trl,conds,@spf_basic_2cond_diff);
% % observed difference
% obs = A-B;
% % proportion of  rows in D that are greater than the observed result
% % if smaller than 0.05 or 0.01 then maybe it is significant
% z = bsxfun(@gt,D,obs);
% p = mean(z,1);

% end
