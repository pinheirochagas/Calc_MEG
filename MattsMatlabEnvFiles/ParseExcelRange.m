function [D1Rng,D2Rng]=ParseExcelRange(InTxt)
% [D1Rng,D2Rng]=ParseExcelRange(InTxt);
%
% Intended to be used after a call to xlsread in Linux, where reading
% partciular ranges doesn't work.
%
% InTxt would be of the form :'D9:F78'
%
% Then D1Rng would be: [9 78]
% and D2Rng would be: [4 6]

len=length(InTxt);
curstr=1;
Strs=cell(4,1);

il=1;
while il<=len           
    switch curstr
        case { 1,3 }
            if isdigit(InTxt(il))
                curstr=curstr+1;                  
                continue
            end
        case 2            
            if strcmp(InTxt(il),':')
                curstr=curstr+1;
                il=il+1;
                continue      
            end
        case 4
            if ~isdigit(InTxt(il))
                error('Weird non-excel range thing found at the end of Input')      
            end        
    end   
    Strs{curstr}(end+1)=InTxt(il);
    il=il+1;
end

%parse the letters to go to D2
D2Rng=[ AlphabetPos(Strs{1}) AlphabetPos(Strs{3}) ];
D1Rng=[ str2num(Strs{2}) str2num(Strs{4}) ];

