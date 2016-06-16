function [output_args] = checkOnsets(subject)

subject = 'sub1'

%%
stimuliPath = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/Calc/' subject '/']; 

for i = 1:10
    [code_event,myEvent,onsets,response,rt] = importStimuli([stimuliPath num2str(i) '_results.csv']);
    
    
end

end


[0.7813 0.7836 0.7835 0.7840 2.3829]

