function ns_maxfilter_er(par)

%% Maxfilter for empty room data%%
script_name=[par.mfdir 'script_mf_' par.outfile]; % define the shell script name (with complete path)

% Compute Maxfilter
fid2            = fopen(script_name, 'w+');
fprintf(fid2, '#!/bin/tcsh\n');
fiffile=[par.rawdir par.subj];
outfile=[par.sssdir par.outfile];

disp(['Performing Maxfilter on dataset ' fiffile '...']);
if isempty(par.badch)             % no bad channels in par.badch
    fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_sss.fif -frame head -origin 0 0 40 -autobad 10000 -badlimit 7\n']);
else                                % bad channels in par.badch for run r
    fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_sss.fif -frame head -origin 0 0 40 -bad ' par.badch ' -autobad 10000 -badlimit 7\n']);
end

fclose(fid2);
cmd = ['chmod 777 ' script_name];   % remove all protections from the shell script (to execute it!)
system(cmd);
cmd = [script_name];                % run the shell script
[status, result] = system(cmd)
