function [Yout Xout]=AvgYAcrossX(Yin,Xin,Xstep,Xrng,f0cut,CalcType)
%function [Yout Xout]=AvgYAcrossX(Yin,Xin,Xstep,Xrng,f0cut,CalcType)
%
%   For the most general title for this function, AvgYAcrossX
%
% Will Avg Yin across the freq vals give in Xin into the output
% frequency bins separated by Xstep with range given by Xrng, and initial bin
% determined by f0cut.
%
% Inputs
%   Yin:          The values to be avreaged across. Could be a single 
%                   numeric array, of dimension NReps x nRawf, or could be 
%                   a 1D cell array of any number of such a numeric array. 
%   Xin:           A 1D vector of length nRawf (matching the 2nd
%                   dimension of numeric arrays of Yin) indicating the
%                   input freequency correspnding to each val of Yin.
%                   Assuemd to be in Hz- though any freq unit could be used
%                   if the other inputs are consistent with that unit.
%   Xstep:          The frequency resolution (in Hz) of the output that the
%                   Yin are averaged into. Defaults to 1/8.
%   Xrng:             A 1x2 or 2x1 vector indicating the output frequency
%                   range to use. Defaults to [0 100].
%   f0cut:          Indicates the upper cutoff frequency used for the 
%                   first bin. ... so the first output bin frequency will
%                   avg Yin from Xrng(1) up to f0cut, and each output bin
%                   will increase in Xstep steps from there. Defaults to
%                   Xstep/2.
%   CalcType:   Indicates how to do the averaging. This can be a
%                   scalar, or if Yin is a cell array, a 1D vector with
%                   each value corresponding to each cell in Yin. This
%                   can also be a scalar if Yin is a cell array, in
%                   which case the value will apply to all cells of Yin.
%                   case:
%                       1 corresponds to a basic nanmean. (for coh mags, abs
%                       vals should be done to the input BEFORE CALLING
%                       this function.) (This is the Default)
%                       2: any function.
%                       3: sum function
%                       4: angle of the sum across frequencies
%                       5: angle of the sum across repetitions and
%                       frequencies. Note that this affects the size of
%                       Yout, by forcing it to have 1 row/rep.
%
% Outputs
%   Yout:        A numeric array or CellArray corresponding to Yin.
%                   Each numeric array will have dimensions nReps x nXout.
%                   (Or possible 1 x nXout if CalcType is set to 5).
%   Xout:           The output frequencies, corresponding to the center
%                   frequency of each frequency bin in Yout.



if nargin < 3 || isempty(Xstep);    Xstep=1/8;     end      %in Hz
if nargin < 4 || isempty(Xrng);    Xrng=[0 100];     end      %in Hz
if nargin < 5 || isempty(f0cut);    f0cut=Xrng(1)+Xstep/2;     end      %in Hz  %this default ensures that Xout will include all values centered on each value that are precisely multiples of Xstep above Xrng(1)   
if nargin < 6 || isempty(CalcType);    CalcType=1;     end


if iscell(Yin)
    CellFlag=1;
    nc=length(Yin);
    if nc>1 && length(CalcType)==1
        CalcType=repmat(CalcType,nc,1);
    end
else    
    CellFlag=0;
end

%Xrng=[0 100];
%Xstep=1/8; %0.25; 
%f0cut=1/16; 


fcut=f0cut:Xstep:Xrng(2);
if fcut(end)<Xrng(2);     fcut(end+1)=Xrng(2);    end
Xout=myRunAvg([Xrng(1) fcut],2);

navgf=length(fcut);
nrawf=length(Xin);
nr=size(Yin,1);

%initialize Yout
if CellFlag
    for ic=1:nc
        if CalcType(ic)==5
            Yout{ic}=repmat(0,1,navgf);
        else
            Yout{ic}=repmat(0,nr,navgf);
        end
    end
else
    if CalcType==5
        Yout=repmat(0,1,navgf);
    else
        Yout=repmat(0,nr,navgf);
    end
end

%need to initialize irawf as the first value above Xrng(1)
irawf=1;
while irawf<=nrawf && Xin(irawf)<Xrng(1)
    irawf=irawf+1;
end

for iavgf=1:navgf   %curFbn=1:nF-1
    %assume starting at 0 for now... so first bin goes from 0 to fcut(1)
    
    iFst=irawf;     %this "preserves" where irawf was at the start of the cycle for this iavgf
    while irawf<=nrawf && Xin(irawf)<=fcut(iavgf)
        irawf=irawf+1;
    end
    iFe=irawf-1;    %roll irawf back one, because above we had to go just past the cutoff to get here
    if iFe>=iFst
        if CellFlag
            for ic=1:nc
                switch CalcType(ic)
                    case 1
                        Yout{ic}(:,iavgf)=nanmean( Yin(:,iFst:iFe),2 );
                    case 2
                        Yout{ic}(:,iavgf)=any( Yin(:,iFst:iFe),2 );
                    case 3
                        Yout{ic}(:,iavgf)=nansum( Yin(:,iFst:iFe),2 );
                    case 4
                        Yout{ic}(:,iavgf)=angle( sum(Yin(:,iFst:iFe),2) )*180/pi;
                    case 5
                        Yout{ic}(1,iavgf)=angle( sum(sum(Yin(:,iFst:iFe),2)) )*180/pi;
                end
            end
        else
            switch CalcType
                case 1
                    Yout(:,iavgf)=nanmean( Yin(:,iFst:iFe),2 );
                case 2
                    Yout(:,iavgf)=any( Yin(:,iFst:iFe),2 );
                case 3
                    Yout(:,iavgf)=nansum( Yin(:,iFst:iFe),2 );
                case 4
                    Yout(:,iavgf)=angle( sum(Yin(:,iFst:iFe),2) )*180/pi;
                case 5
                    Yout(1,iavgf)=angle( sum(sum(Yin(:,iFst:iFe),2)) )*180/pi;
            end
        end
    else
        if CellFlag
            for ic=1:nc
                Yout{ic}(:,iavgf)=NaN;
            end
        else
            Yout(:,iavgf)=NaN;
        end
    end
end