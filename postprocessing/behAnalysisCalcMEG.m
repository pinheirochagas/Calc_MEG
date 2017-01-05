function behAnalysisCalcMEG(subs)

%% Load response key
load('response.mat')
response(22,2) = 2
response = response([1:19 21 22],:)


%% Loop accross subjects
for sub = 1:length(subs)
    %% Load data
    load([datapath subs{sub} '_calc.mat'])
    trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    
    %% Add accuracy
    for ii = 1:size(trialinfo,1)
        if response(sub,2) == 1
            if trialinfo(ii,1) < 6
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == -1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == 1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            else
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == 1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == -1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end                
            end
        else
            if trialinfo(ii,1) < 6
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == 1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == -1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            else
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == -1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == 1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end   
            end
        end
    end
        trialinfoAll{sub} = trialinfo;
        clear trialinfo
        clear data
end


trialinfoALL = vertcat(trialinfoAll{:})

trialinfoALL = trialinfoALL(trialinfoALL(:,10)<2000,:)

boxplot(trialinfoALL(:,10),trialinfoALL(:,1))



end


hist(trialinfoALL(:,10))



end
