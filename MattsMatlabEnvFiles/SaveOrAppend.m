function outstr=SaveOrAppend(file,savestr,ForceSave);
% function outstr=SaveOrAppend(file,savestr,ForceSave);
%   Usually called: eval(SaveOrAppend(file,savestr))
%
% Checks to see if a file already exists in the file path and name input as
% FILE, and outputs a string that should be used by eval to create the file
% if it does not exist, or append it if it does exist. This executes a
% disp statement explaining what file is about to be created or appended.
% If ForceSave is set to 1, it will Save without append even if the file 
% already exists, thus writing over what was there
%
% WARNING!!!! the filename in FILE must end in '.mat', assuming the file is
% a mat file, for the method to work and to avoid saving over it
%
% Use double quotes in SAVESTR for every intended quote in outstr
% example inputs-   SaveOrAppend('matpath\TheoBehSum','''a'',''b''')
%                   This outputs: outstr= save('matpath\TheoBehSum','a','b');
%                       and the output would optionally have '-append' in
%                       it depending on whether or not the file existed

if nargin<3|isempty(ForceSave)  ForceSave=0;    end

if nargin<2
    if exist(file,'file')
        if ~ForceSave
            disp(['Appending ' file ', which was found.'])
            outstr=['save(''' file ''',''-append'');'];
        else
            disp(['Forced-saving over ' file ', which was found.'])
            outstr=['save(''' file ''');'];
        end
    else
        disp(['Creating ' file ', which was NOT found.'])
        outstr=['save(''' file ''');'];
    end
else
    if exist(file,'file')
        if ~ForceSave
            disp(['Appending ' file ', which was found.'])
            outstr=['save(''' file ''',' savestr ',''-append'');'];
        else
            disp(['Forced-saving over ' file ', which was found.'])
            outstr=['save(''' file ''',' savestr ');'];
        end
    else
        disp(['Creating ' file ', which was NOT found.'])
        outstr=['save(''' file ''',' savestr ');'];
    end
end
%disp('stop')