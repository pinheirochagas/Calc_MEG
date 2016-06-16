function trialinfo = integrate_behavior_data(alltrigNew)

for i = 1:length(alltrigNew)
    alltrigRun = alltrigNew{i};
    for ii = 1:length(alltrigRun)
        trialinfo.run = i;
        trialinfo.operand1 = alltrigRun{ii}(1,2)-1;
        if alltrigRun{ii}(2,2) == 51
            trialinfo.operator = -1;        % subtraction
        elseif alltrigRun{ii}(2,2) == 53
            trialinfo.operator = 1;         % addition
        elseif alltrigRun{ii}(2,2) == 54
            trialinfo.operator = 0;         % comparison
        end
        trialinfo.operand2 = alltrigRun{ii}(3,2)-21; % equal sign here will have the value of 33
        
        if alltrigRun{ii}(5,2) >= 31 && alltrigRun{ii}(5,2) <= 40
           trialinfo.presResult = alltrigRun{ii}(5,2)-31;
           trialinfo.delay = 0;
        elseif alltrigRun{ii}(5,2) >= 41 && alltrigRun{ii}(5,2) <= 50
           trialinfo.presResult = alltrigRun{ii}(5,2)-41;
           trialinfo.delay = 1;
        end
      
        if trialinfo.operand2 ~= 33
            trialinfo.corrResult = trialinfo.operand1 + trialinfo.operand2*trialinfo.operator;
        else
            trialinfo.corrResult = trialinfo.operand1;
        end
        trialinfo.deviant = trialinfo.presResult-trialinfo.corrResult;
        trialinfo.absdeviant = abs(trialinfo.deviant);
        
        if length(alltrigRun{ii}) == 6
            trialinfo.rt = alltrigRun{ii}(6,1) - alltrigRun{ii}(5,1);
           if alltrigRun{ii}(6,2) == 1024;
              trialinfo.respSide = 1; % right button
           elseif alltrigRun{ii}(6,2) == 32768;
              trialinfo.respSide = -1; % left button
           end
        else
           trialinfo.resSide = 0; % no response
           trialinfo.rt = 0;  % no response
        end
        trialinfoRun{i}{ii} = trialinfo;
        run{i}(ii) = trialinfo.run;
        operand1{i}(ii) = trialinfo.operand1;
        operator{i}(ii) = trialinfo.operator;
        operand2{i}(ii) = trialinfo.operand2;
        presResult{i}(ii) = trialinfo.presResult;
        delay{i}(ii) = trialinfo.delay;
        corrResult{i}(ii) = trialinfo.corrResult;
        deviant{i}(ii) = trialinfo.deviant;
        absdeviant{i}(ii) = trialinfo.absdeviant;
        rt{i}(ii) = trialinfo.rt;
        respSide{i}(ii) = trialinfo.respSide;
        
   end
end

%% Put trialinfo in darinka and sebs format

for i = 1:length(run)
    trialinfoF(i).run = run{i}; 
    trialinfoF(i).operand1 = operand1{i};
    trialinfoF(i).operator = operator{i};
    trialinfoF(i).operand2 = operand2{i};
    trialinfoF(i).presResult = presResult{i};
    trialinfoF(i).delay = delay{i};
    trialinfoF(i).corrResult = corrResult{i};
    trialinfoF(i).deviant = deviant{i};
    trialinfoF(i).absdeviant = absdeviant{i};
    trialinfoF(i).rt = rt{i};
    trialinfoF(i).respSide = respSide{i};
end
trialinfo = trialinfoF;

end


