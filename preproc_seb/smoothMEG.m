function dataSmooth = smoothMEG(subName, task)
% This function smooths and/or average in a sliding window of XXms the
% signal of the Calculation experiment (for decoding analysis mostly)
% Smooth MEG data
% subName = 's01'
% task = 'calc' or 'VSA'

%datadir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/mat/';
datadir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/mat/';
%datadir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';

load([datadir subName '_' task '.mat'])

winSize_s = 0.1; %smoothing window
winSize = floor(data.fsample*winSize_s);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

for trial = 1:length(data.trial)
    for chan = 1:size(data.trial{1},1)
        datatoAVG = data.trial{trial}(chan,:);
%         for timewin = 1:length(avgwindows)-1
%             dataAVGwin{timewin} = repmat(mean(datatoAVG(avgwindows(timewin): avgwindows(timewin+1))),window,1);
%         end
%         dataAVG{trial}(chan,:) = vertcat(dataAVGwin{:})';
        dataSmooth{trial}(chan,:) = convn(datatoAVG,gusWin','same');
    end
end
% Correct the time vector size 
%datasmooth.time = data.time;
%
%datasmooth.trial = dataSmooth;

% Save updated data in a new file
%save([datadir subName '_' task '_smooth.mat'], 'data')


% % % Some plotting to compare avg window and smoothing
% dataAVG = dataAVG{1}(1,:)
% dataSmooth = dataSmooth{1}(1,:)
% timeSmooth = timeSmooth{1}(1,:)
% hold on
% plot(times,datatoAVG, 'm-')
% plot(times(1:length(dataAVG)), dataAVG, 'b-', 'LineWidth', 3)
% plot(times(avgwindows(1:end-1)), dataAVG(avgwindows(1:end-1)),'k.', 'MarkerSize', 30)
% plot(timeSmooth,dataSmooth, 'y-','LineWidth', 3)   

end

