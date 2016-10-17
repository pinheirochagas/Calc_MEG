function AddLeadingZerosToFileName(curdir)
% function AddLeadingZerosToFileName(curdir)
%
% Scrolls through all of the files in a directory, for those with file 
% names ending inn numbers, it adds leading zero to those number in the
% filenames as needed. This helps for keeping files in order when running
% dir(*.ncs) for example.
%
% Runs in pwd if given no input directory

if nargin<1 || isempty(curdir);     curdir=pwd;     end

disp(['Working in ' curdir])
enddir=pwd;
cd(curdir)

FileList=dir(curdir);
nfiles=length(FileList);

LastDigs=cell(nfiles);
DigsStPos=zeros(nfiles,1);
AllLen=zeros(nfiles,1);
% Loop to GetThe LastDigs, DigsStPos and MaxNDigs       
for ifile=1:nfiles
    [LastDigs{ifile},DigsStPos(ifile)] = GetLastDigsBeforeExt(FileList(ifile).name);
    
    AllLen(ifile)=length(LastDigs{ifile});
end
MaxNDigs=max(AllLen);
 
% Assign new filenames using unix command       
for ifile=1:nfiles
    if AllLen(ifile)<MaxNDigs  &&  ~isempty(LastDigs{ifile})  
        nNewChars=MaxNDigs-AllLen(ifile);
        newfname=[ FileList(ifile).name(1:DigsStPos(ifile)-1)   repmat('0',1,nNewChars) LastDigs{ifile}  FileList(ifile).name( DigsStPos(ifile)+AllLen(ifile):end ) ];                
        disp(['Renaming  ' FileList(ifile).name '  to  ' newfname])
        
        %Execute Unix command mv  
        unix(['mv ' FileList(ifile).name ' ' newfname]);
    end
end

cd(enddir)