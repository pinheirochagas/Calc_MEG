function trialinfo = integrate_behavior_dataVSA(alltrigNew)

for i = 1:length(alltrigNew)
    alltrigRun = alltrigNew{i};
    for ii = 1:length(alltrigRun)
        trialinfo.run = i;
        trialinfo.cue = alltrigRun{ii}(1,2); % 1 = left side, 2 = right side  
        trialinfo.targetAll = alltrigRun{ii}(2,2); % combined info about the target (side and identity)
        % Define target identity 
        if alltrigRun{ii}(2,2) == 10 || alltrigRun{ii}(2,2) == 11
            trialinfo.target = 10;        % T
        elseif alltrigRun{ii}(2,2) == 12 || alltrigRun{ii}(2,2) == 13
            trialinfo.target = 12;      % L
        end
        % Define target side 
        if alltrigRun{ii}(2,2) == 10 || alltrigRun{ii}(2,2) == 12
            trialinfo.targetSide = 1;        % left side
        elseif alltrigRun{ii}(2,2) == 11 || alltrigRun{ii}(2,2) == 13
            trialinfo.targetSide = 2;      % right side
        end
        % Define congruency 
        if trialinfo.targetSide == trialinfo.cue
            trialinfo.congruency = 1;        % left side
        else
            trialinfo.congruency = 0;      % right side
        end
       % Define response and RT
        if length(alltrigRun{ii}) == 3
            trialinfo.rt = alltrigRun{ii}(3,1) - alltrigRun{ii}(2,1);
           if alltrigRun{ii}(3,2) == 1024;
              trialinfo.respSide = 1; % right button
           elseif alltrigRun{ii}(3,2) == 32768;
              trialinfo.respSide = -1; % left button
           end
        else
           trialinfo.respSide = 0; % no response
           trialinfo.rt = 0;  % no response
        end
       
        run{i}(ii) = trialinfo.run;
        cue{i}(ii) = trialinfo.cue;
        targetAll{i}(ii) = trialinfo.targetAll;
        target{i}(ii) = trialinfo.target;
        targetSide{i}(ii) = trialinfo.targetSide;
        congruency{i}(ii) = trialinfo.congruency;
        rt{i}(ii) = trialinfo.rt;
        respSide{i}(ii) = trialinfo.respSide;
        
   end
end

%% Put trialinfo in darinka and sebs format

for i = 1:length(run)
    trialinfoF(i).run = run{i}; 
    trialinfoF(i).cue = cue{i};
    trialinfoF(i).targetAll = targetAll{i};
    trialinfoF(i).target = target{i};
    trialinfoF(i).targetSide = targetSide{i};
    trialinfoF(i).congruency = congruency{i};
    trialinfoF(i).rt = rt{i};
    trialinfoF(i).respSide = respSide{i};
    
end
trialinfo = trialinfoF;

end


