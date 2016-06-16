 function ns_maxfilter_calc(par)

%% Maxfilter %%
script_name=[par.mfdir 'script_mf_' par.subj]; % define the shell script name (with complete path)

% Avoid computing maxfilter on fake meanhp run
if strcmp(par.runlabel(end),'meanhp')==1
    lastrun=length(par.run)-1;
else lastrun=length(par.run);
end

% Compute Maxfilter
fid2            = fopen(script_name, 'w+');
fprintf(fid2, '#!/bin/tcsh\n');
for r=1:lastrun
    fiffile=[par.rawdir par.subj par.runlabel{r}];
    outfile=[par.sssdir par.subj par.runlabel{r}];
    reffile=[par.rawdir par.subj par.runlabel{par.hprun}];
    disp(['Performing Maxfilter on dataset ' fiffile '...']);
    
%             maxfilter  -f input_file.fif  -o output_file.fif  -st  -origin 0 0 45  -frame head  -autobad on  -movecomp  -format short  -force

    if par.tss == 0 % simple SSS
        if isempty(par.skip{r})                  % nothing to skip in par.skip for run r
            if isempty(par.badch{r})             % no bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_sss.fif -frame head -origin 0 0 40 -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            else                                % bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_sss.fif -frame head -origin 0 0 40 -bad ' par.badch{r} ' -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            end        
        else                                     % there is something to skip in par.skip for run r
            if isempty(par.badch{r})             % no bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_sss.fif -frame head -origin 0 0 40 -skip ' par.skip{r} ' -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            else                                % bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_sss.fif -frame head -origin 0 0 40 -bad ' par.badch{r} ' -skip ' par.skip{r} ' -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            end
        end
        
    else   % temporal extension of SSS
                if isempty(par.skip{r})                  % nothing to skip in par.skip for run r
            if isempty(par.badch{r})             % no bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_tsss.fif -st -frame head -origin 0 0 40 -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            else                                % bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_tsss.fif -st -frame head -origin 0 0 40 -bad ' par.badch{r} ' -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            end        
        else                                     % there is something to skip in par.skip for run r
            if isempty(par.badch{r})             % no bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_tsss.fif -st -frame head -origin 0 0 40 -skip ' par.skip{r} ' -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            else                                % bad channels in par.badch for run r
                fprintf(fid2, ['maxfilter -force -f ' fiffile '.fif -o ' outfile '_tsss.fif -st -frame head -origin 0 0 40 -bad ' par.badch{r} ' -skip ' par.skip{r} ' -autobad 10000 -badlimit 7 -trans ' reffile '.fif\n']);
            end
                end
    end
    
end
fclose(fid2);
cmd = ['chmod 777 ' script_name];   % remove all protections from the shell script (to execute it!)
system(cmd);
cmd = [script_name];                % run the shell script
[status, result] = system(cmd)