function Ph=UnWrapPh(Ph,usematlab,jumptol,posjumpflag)
% function Ph=UnWrapPh(Ph)
% 
% Written 061012 by Matt Nelson- I just found out matlab has a function for
% this, so I'm just writing this specifically for use with ImpAnal and
% ImpAnalElec; and writing the scripts to employ that function on that
% data. It asumed Ph is a 2D Nrec x 2 cell array, with recording wlong the first
% cell dimension, with spike channel data in the second column, and LFP
% channel data down the first column; but it will work for a cell array
% with multiple columns. Inside each cell is a vector with the phase data
% (assumed to be in degrees here, but the matlab fxn accepts radians)
% across frequencies for the gievn recording.
%
% If usematlab is set to 0 in input, it uses a custom design that
% specifically rejects large negative jumps that are greater than jumptol
% (enter jumptol in degrees).   If posjumpflag is further entered as 1, it
% rejects positive jumps greater than jumptol
%
% This fxn outputs data in degrees
%
% use UNWRAP (a matlab fxn) if you want to do this to one vector, or a
% matrix    *Note the data for phases must be in radians!
%

if nargin<2 usematlab=1;    end
if nargin<3 jumptol=100; end
if nargin<4 posjumpflag=0; end

for irec=1:size(Ph,1)
    for itype=1:size(Ph,2)
        if usematlab
            Ph{irec,itype}=unwrap(Ph{irec,itype}*pi/180)*180/pi;
        else
            if posjumpflag
                for iF=2:length(Ph{irec,itype})
                    %disp(['Checking iF: ' num2str(iF) ' for irec: ' num2str(irec) ' and itype: ' num2str(itype)])
                    while Ph{irec,itype}(iF)-Ph{irec,itype}(iF-1)>jumptol
                        %disp(['adjusting irec: ' num2str(irec) ' itype: ' num2str(itype) ' iF: ' num2str(iF)])
                        %disp(['was: ' num2str(Ph{irec,itype}(iF))])
                        Ph{irec,itype}(iF)=Ph{irec,itype}(iF)-360;
                        %disp(['now is: ' num2str(Ph{irec,itype}(iF))])
                    end
                end
            else
                for iF=2:length(Ph{irec,itype})
                    %disp(['Checking iF: ' num2str(iF) ' for irec: ' num2str(irec) ' and itype: ' num2str(itype)])
                    while Ph{irec,itype}(iF-1)-Ph{irec,itype}(iF)>jumptol
                        %disp(['adjusting irec: ' num2str(irec) ' itype: ' num2str(itype) ' iF: ' num2str(iF)])
                        %disp(['was: ' num2str(Ph{irec,itype}(iF))])
                        Ph{irec,itype}(iF)=Ph{irec,itype}(iF)+360;
                        %disp(['now is: ' num2str(Ph{irec,itype}(iF))])
                    end
                end
            end
        end
    end
end