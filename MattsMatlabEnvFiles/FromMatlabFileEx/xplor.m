%XPLOR.M starts up Windows Explorer in the current working directory.
%
%(C) 20/03/01 J.Bishop

if exist('c:\windows')
    dos('c:\windows\explorer /e, .');
elseif exist('c:\winnt40')
    dos('c:\winnt40\explorer /e, .');
elseif exist('c:\winnt')
    dos('c:\winnt\explorer /e, .');
else
	disp('Unable to locate Explorer, please locate explorer.exe on your system and add its path to xplor.m')
end

