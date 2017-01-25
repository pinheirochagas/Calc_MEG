function trialinfo = addAccuracy(subs)

%% Paths
addPathInitDirsMEGcalc

%% Load response key
load('response_key.mat')


%% Loop accross subjects
for sub = 1:length(subs)
    %% Load data
    load([data_dir subs{sub} '_calc.mat'])
    trialinfo_loop = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    trialinfo = data.trialinfo; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    clear data
    
    %% Add accuracy
    for ii = 1:size(trialinfo_loop,1)
        if response(sub,2) == 1
            if trialinfo_loop(ii,1) < 6
                if (trialinfo_loop(ii,8) == 0 && trialinfo_loop(ii,11) == -1) || (trialinfo_loop(ii,8) ~= 0 && trialinfo_loop(ii,11) == 1)
                    trialinfo_loop(ii,12) = 1;
                else
                    trialinfo_loop(ii,12) = 0;
                end
            else
                if (trialinfo_loop(ii,8) == 0 && trialinfo_loop(ii,11) == 1) || (trialinfo_loop(ii,8) ~= 0 && trialinfo_loop(ii,11) == -1)
                    trialinfo_loop(ii,12) = 1;
                else
                    trialinfo_loop(ii,12) = 0;
                end
            end
        else
            if trialinfo_loop(ii,1) < 6
                if (trialinfo_loop(ii,8) == 0 && trialinfo_loop(ii,11) == 1) || (trialinfo_loop(ii,8) ~= 0 && trialinfo_loop(ii,11) == -1)
                    trialinfo_loop(ii,12) = 1;
                else
                    trialinfo_loop(ii,12) = 0;
                end
            else
                if (trialinfo_loop(ii,8) == 0 && trialinfo_loop(ii,11) == -1) || (trialinfo_loop(ii,8) ~= 0 && trialinfo_loop(ii,11) == 1)
                    trialinfo_loop(ii,12) = 1;
                else
                    trialinfo_loop(ii,12) = 0;
                end
            end
        end
    end
    
    %% Put back to original trialinfo format
    trialinfo.accuracy = trialinfo_loop(:,12)';
    
end

end

