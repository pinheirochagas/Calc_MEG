function [ MnStats,MedStats ]= MeanAndMedTests( x,y,lab1,lab2 )

%done here for diffs of two samples...
%but this should work for one sample if you put y in as all zeroa   

MnStats.MnDiff= nanmean(x-y);
MedStats.MedDiff= nanmedian(x-y);

[~,MnStats.p,~,stats] = ttest( x,y );
MnStats.df=stats.df;
MnStats.tstat=stats.tstat;
disp([lab1 ' - ' lab2 ' mean(median) difference is '  myRoundForDisp3(MnStats.MnDiff,-2) '(' myRoundForDisp3(MedStats.MedDiff,-2) ')  t(' num2str(MnStats.df) ') = ' myRoundForDisp3(MnStats.tstat,-2) ';  p=' myRoundForDisp3(MnStats.p,-4)]) 

[MedStats.p,~,stats2]=signrank( x,y,'method','exact' );
MedStats.signedrank=stats2.signedrank;
disp(['W(' num2str(MnStats.df) ') = ' myRoundForDisp3(MedStats.signedrank,-2) ';  p=' myRoundForDisp3(MedStats.p,-4)])


