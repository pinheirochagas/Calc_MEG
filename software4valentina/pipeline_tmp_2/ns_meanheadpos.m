function par=ns_meanheadpos(par)

%% Compute Mean Head Position between runs
% Generate a shell script that extracts the head position for each run and
% saves it in a txt file
script_name=[par.hpdir 'script_mhp_' par.subj];  % define the shell script name (with complete path)
fd2         = fopen(script_name, 'w+');         % open the shell script
fprintf(fd2, '#!/bin/tcsh\n');
fprintf(fd2, ['cd ' par.rawdir '\n']);
fprintf(fd2, 'dataHandler -r -avg ');
for r=par.run
    fiffile=[par.rawdir par.subj par.runlabel{r}];                          % name of fif file from which head position should be extracted
    fprintf(fd2, [fiffile '.fif ']);    % print the command for extracting the head position in the shell script
end;
fprintf(fd2, ['-hp mean -time 0 -.1 ' par.rawdir par.subj 'meanhp.fif']);
fclose(fd2);
cmd = ['chmod 777 ' script_name];       % remove all protections from the shell script (to execute it!)
system(cmd);
cmd = [script_name];                    % run the shell script
[status, result] = system(cmd);
disp(result);

% Add fake run containing mean head position
if strcmp(par.runlabel(end),'meanhp')==0
    par.runlabel(length(par.runlabel)+1) = {'meanhp'};
    par.run         = 1:length(par.runlabel); % Update number of runs
else
    disp(['Mean Head position was already computed. Re-written.']);
end;
% if status==0
%     error('Error while retrieving one or more head positions. Please check file names and head position data within .fif files.');
% else
%     disp(['status = ' num2str(status)]);
%     disp(['result = ' result]);
% end;

% dataHandler -r -avg s05r1.fif s05r2.fif s05r3.fif s05r4.fif s05r5.fif s05r6.fif s05r7.fif s05r8.fif -hp mean -time 0 -.1 s05meanhp.fif
% 
% dataHandler -r -hc s05r1.fif s05r2.fif s05r3.fif s05r4.fif s05r5.fif s05r6.fif s05r7.fif s05r8.fif s05meanhp.fif
% 
% Then I want to CHECK DISTANCES BETWEEN RUNS!
% 
% Visualization:
% /neurospin/meg/meg_tmp/tools_tmp/megDraw/megDraw s05*.hc



