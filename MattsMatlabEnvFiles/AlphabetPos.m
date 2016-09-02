function outnum = AlphabetPos(inchar)
%function outnum = AlphabetPos(inchar)
%
% Given a character string (i.e. D) give that strings position in the
% alphabet (i.e. 4)
%
% This was needed for the use of ParseExcelRange.m

alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';

outnum=0;
len=length(inchar);
expon=len-1;
for il=1:len           
    outnum=outnum+( findstr( alphabet,inchar(il) ) )*26^expon;      %base 26!
    expon=expon-1;
end




