function behAnalysisCalcMEG(subs)

%% Load response key
load('response.mat')


%% Loop accross subjects
for sub = 1:length(subs)
    %% Load data
    load([datapath subs{sub} '_calc.mat'])
    trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    
    %% Add accuracy
    for ii = size(trialinfo,1)
        if response(sub) == 1
            if trialinfo(ii,1) < 6
                if trialinfo(ii,8) == 0 && trialinfo(ii,11) == 1
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            else
                if trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == -1
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            end
        else
            if trialinfo(ii,1) >= 6
                if trialinfo(ii,8) == 0 && trialinfo(ii,11) == -1
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            else
                if trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == 1
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            end
        end
    end
    
    
end







end




end
