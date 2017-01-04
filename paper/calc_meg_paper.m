%% Pipeline for the Calc_MEG paper

%% Set paths and directories
addPathInitDirsMEGcalc

%% Behavior analysis

subs = {'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};
    
    % Load all data from all subjects (needs at least 30 gb free in disk space)
for sub = 1:length(subs)
    load([datapath subs{sub} '_calc.mat'])
    data.trialinfoCustom = data.trialinfo; 
    data.trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    dataAll.(subs{sub}) = data;
    clear data
end


