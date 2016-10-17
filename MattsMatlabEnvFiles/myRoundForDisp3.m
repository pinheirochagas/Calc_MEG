function [outstr,outn]=myRoundForDisp3(n,RndDig,forceflag)
%function myRoundForDisp3(num,dec,forceflag)
%
%   NOTE- This RoundForDisp only outputs the str of teh first output cell,
%   and does so in a string format, to allow for a direct concatenation of
%   the output with other strings...
%
%   Example where this is needed: in PlotRMCheckFig.m:
%       th=text(.8,.7,[myRoundForDisp3(PctNSW*100,-1) '% W']);
%       With myRoundForDisp2, this display the number and '% W' on
%       different text lines, b/c the output of myRoundForDisp2 is a cell
%       array, not a string
%
%   RE-started on 070105 because I got tired of waiting to ask for previous
%   version... MJN
%   Outputs a formatted number version of NUM based on inputs, see below for
%   details.
%
%   INPUTS:
%   n:        The numeric number(s) you want formatted.
%   RndDig:     The digit place you want to round to in terms of powers of
%               10. i.e. for 0, round to nearest integer, for -1 round to
%               nearest tenth, etc. DEFAULTS to 0
%   FORCEFLAG:  set to 0 to round to nearest, set to anything greater than
%               0 to always round up, set to anything less than 0 to always
%               round down. DEFAULTS to 0
%
%   OUTPUTS:    OUTN- formatted number(s), size of n
%               OUTSTR- a cell array of formatted String(s), size of n
%
%   As of today (070105) There are a lot more things that can be added to
%   this (that were on the nicer earlier version) that can be added on a
%   need-based basis.       (like what to do with a negative sign for the
%   string output)

if nargin<3||isempty(forceflag);      forceflag=0;    end
if nargin<2||isempty(RndDig);         RndDig=0;    end

n=n*10^(-RndDig);   %adjust the input for rounding
if forceflag==0
    outn=round(n);
elseif forceflag>0
    outn=ceil(n);
else
    outn=floor(n);
end
tmpoutn=outn;       %adjusts the input back
outn=outn*10^(RndDig);

[nr, nc]=size(n);
outstr=cell(nr,nc);

if length(size(n))==2   %1 or 2D input
    for ir=1:nr
        for ic=1:nc
            if RndDig<0 && (n(ir,ic) < 1 || isint(tmpoutn(ir,ic)/10)) %This means the last rounded digit is a zero
                if outn(ir,ic)==0 || abs(n(ir,ic)) < 1 %
                    if n==0
                        if RndDig<0
                            outstr{ir,ic}=['0.' repmat('0',1,-RndDig)];
                        else    outstr{ir,ic}='0';  
                        end
                    else
                        n(ir,ic)=n(ir,ic)*10^(RndDig);    %we need to convert n back b/c of RndDig adjustment above...
                        pow=ceil(-log10(n(ir,ic)));    %we need to convert n back b/c of RndDig adjustment above...
                        outstr{ir,ic}=num2str(n(ir,ic)*10^pow);
                        outstr{ir,ic}=[outstr{ir,ic}(1:min(length(outstr{ir,ic}),3)) 'e-' num2str(pow)];
                    end
                else
                    if outn>0
                        outstr{ir,ic}=num2str(outn(ir,ic)+1*10^(RndDig-1)); %Thuis fixes it so that it outputs the rounded digits if it's rounding to some decimal place less than one
                    else
                        outstr{ir,ic}=num2str(outn(ir,ic)-1*10^(RndDig-1)); %Thuis fixes it so that it outputs the rounded digits if it's rounding to some decimal place less than one
                    end
                    %if ~isint( outn(ir,ic) )
                    outstr{ir,ic}=outstr{ir,ic}(1:end-1);
                    %end
                end
            else
                outstr{ir,ic}=num2str(outn(ir,ic));
            end
        end
    end
    
elseif length(size(n))==3   %3D input
    for ir=1:nr
        for ic=1:nc
            for ip=1:size(n,3)
                if RndDig<0 && isint(tmpoutn(ir,ic,ip)/10) %This means the last rounded digit is a zero
                    outstr{ir,ic,ip}=num2str(outn(ir,ic,ip)+1*10^(RndDig-1)); %Thuis fixes it so that it outputs the rounded digits if it's rounding to some decimal place less than one
                    outstr{ir,ic,ip}=outstr{ir,ic,ip}(1:end-1);
                else
                    outstr{ir,ic,ip}=num2str(outn(ir,ic,ip));
                end
            end
        end
    end
end

if nr==1 && nc==1
    outstr=outstr{1,1};
end