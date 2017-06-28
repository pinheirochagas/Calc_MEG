function trialinfo = addAccuracy(subject)

%% Paths
AddPathsMEGcalc
InitDirsMEGcalc

%% Load response key
load('response_key.mat')
response(end,2) == 1; % correct for apparent mistake on subject 22

%% Loop accross subjects
for sub = 1:length(subject)
    %% Load data
    load([data_dir subject{sub} '_calc_AICA.mat'])
    trialinfo_loop = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    trialinfo = data.trialinfo; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    
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
    
    %% Add accuracy
    trialinfo.accuracy = trialinfo_loop(:,12)';
    
    %% Add correct_choice column
    correct_choice = zeros(1,length(trialinfo_loop),1);
    for i = 1:length(trialinfo_loop)
        if (trialinfo.accuracy(i) == 1 && trialinfo.deviant(i) == 0) || (trialinfo.accuracy(i) == 0 && trialinfo.deviant(i) == 0)
            correct_choice(i) = 1;
        elseif (trialinfo.accuracy(i) == 1 && trialinfo.deviant(i) ~= 0) || (trialinfo.accuracy(i) == 0 && trialinfo.deviant(i) ~= 0)
            correct_choice(i) = 0;
        end
    end
    trialinfo.correct_choice = correct_choice;    
    trialinfo
    
    %% Put back to original trialinfo format
    data.trialinfo = trialinfo;
    
    
    %% Plug back to data and save
    save([data_dir par.Sub_Num,'_calc_AICA_acc.mat'], 'data', 'par')   % Save the structure in MAT file
    display(['accuracy ' subject{sub} ' done'])
end

end

