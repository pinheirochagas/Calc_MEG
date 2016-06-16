function EEG=bst2eeglab

badep=[1 5 6 7 13 14 177 182 183 199];
dirin='D:\Documents and Settings\mbuiatti\Mes documents\FromOmega\projects\bilatnum\datas15\data\test_ica\4_raw\';
dirout='D:\Documents and Settings\mbuiatti\Mes documents\FromOmega\projects\bilatnum\datas15\data\test_ica\';
rootname='4_raw_';

list=10:232;
list=setdiff(list,badep);
for ep=1:50
    load([dirin rootname num2str(list(ep))]);
    Ftot(:,:,ep)=F;
end;

EEG = pop_importdata('dataformat','array','nbchan',0,'data','Ftot','srate',1000,'pnts',0,'xmin',Time(1));