function ns_drawheadpos(par)

%% Draw Head Position of all runs
% Generate a shell script that extracts the head position for each run and
% saves it in a txt file
script_name=[par.hpdir 'script_dhp_' par.subj];  % define the shell script name (with complete path)
fd2         = fopen(script_name, 'w+');         % open the shell script
fprintf(fd2, '#!/bin/tcsh\n');
fprintf(fd2, ['cd ' par.hpdir '\n']);
fprintf(fd2, 'dataHandler -r -hc ');
for r=par.run
    fiffile=[par.rawdir par.subj par.runlabel{r}];                          % name of fif file from which head position should be extracted
    fprintf(fd2, [fiffile '.fif ']);    % print the command for extracting the head position in the shell script
end;
fprintf(fd2, '\n');
fprintf(fd2, ['/neurospin/meg/meg_tmp/tools_tmp/megDraw/megDraw ' par.hpdir par.subj '*.hc ']);
fclose(fd2);
cmd = ['chmod 777 ' script_name];       % remove all protections from the shell script (to execute it!)
system(cmd);
cmd = [script_name];                    % run the shell script
[status, result] = system(cmd);
disp(result);
% if status==0
%     error('Error while retrieving one or more head positions. Please check file names and head position data within .fif files.');
% else
%     disp(['status = ' num2str(status)]);
%     disp(['result = ' result]);
% end;

% dataHandler -r -hc s05r1.fif s05r2.fif s05r3.fif s05r4.fif s05r5.fif s05r6.fif s05r7.fif s05r8.fif s05meanhp.fif
% 
% Then I want to CHECK DISTANCES BETWEEN RUNS!
% 
% Visualization:
% /neurospin/meg/meg_tmp/tools_tmp/megDraw/megDraw s05*.hc



