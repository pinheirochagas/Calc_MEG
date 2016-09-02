function WkDayList=myWeekday(InCell)
%function WkDayList=myWeekday(InCell)
%
% Takes in a given 1 or 2D cell array InCell of dates in Matt's preferred
% format (yymmdd) and returns in wkDayList a numeric array of the same size
% as InCell that indcates the day of the week of each corresponding day. 
%
% for compatibility with the ParisImpPatch dataset for which this function
% is initially being written, this will only look at the first 6 letters of
% each string in InCell to get the date.

[r c]=size(InCell);
WkDayList=repmat(NaN,r,c);

for ir=1:r
    for ic=1:c
        WkDayList(ir,ic)= weekday( datestr( [2000+str2num(InCell{ir,ic}(1:2)) str2num(InCell{ir,ic}(3:4)) str2num(InCell{ir,ic}(5:6)) 0 0 0] ) );
    end
end               