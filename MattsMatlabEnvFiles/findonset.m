function onsamp=findonset(chkdata,basedata,nonsamps,pcton,nrels,nrels2,usebasemax,belowflag)
% function onsamp=findonset(chkdata,basedata,nonsamps,pcton,nrels,nrels2,usebasemax,belowflag)
%
% Written 061119 by Matt Nelson. Finds the onset time of the values in
% chkdata based on the Schall Lab-style method of determing the first point
% in time wher a certain pct of data points are above a certain value for a
% certain duration.
%
% INPUTS:   chkdata-    The data you want to look at, can be a vector or a
%                       2D array. The fxn looks down the longest dimension 
%                       and retruns a value for each individual column or row
%           basedata-   The data you want to use for the baseline,
%                       following conventions used in chkdata. i.e. if 
%                       chkdata has each data series down its rows, so 
%                       should basedata. Can also be a scalar or a vector
%                       with one val for each data series to use as the 
%                       cutoff rather than calculating it from input basedata
%           nonsamps-   The number of samps over which to find a certain 
%                       percentage of points it has to be above the cutoff 
%                       value to register as on. DEFAULTS to 50
%           pcton-      The percentage of points over nonsamps samples that
%                       have to be above the cutoff value to register as 
%                       on. DEFAULTS to 1.00
%           nrels-      The number of either stds or maxvalues of the
%                       baseline data that serve as the cutoff point. Can 
%                       be a scalar or a vector 
%                       DEFAULTS to 2
%           nrels2-      The number of either stds or maxvalues of the
%                       baseline data that the chkdata must reach at least 
%                       once over an activation period for an onset to be
%                       detected. DEFAULTS to 6
%           usebasemax- set to 1 to use the maximum value over the baseline
%                       data vas the relative value for the cutoffpoint, or
%                       set to 0 to use it's std. DEFAULTS to 0
%           belowflag-  set to 1 to search for when the fxn is less than 
%                       the cutoff value. This is useful when chkdata is 
%                       something like say the mean-squared error for cases
%                       when you want to determine when a model stops or 
%                       starts adequately fitting the data. Set to 0 to 
%                       search for when it is greater than the cutoff 
%                       value. DEFAULTS to 0
%           
% OUTPUTS:  onsamp-     The sample number of the onset in the data gievn
%                       the input parameters. set to NaN if no onset is found.
%
% See Also: FINDOFFSET

%First check first two inputs
if nargin<2 error('You need at least two input arguments for this fxn!');    end
schk=size(chkdata);
sb=size(basedata);
if length(sb)>2 ||   length(sb)>2    error('Chkdata and basedata can''t be more than 2D!');   end   
[dlen,ind]=max(schk);
if ind==1
    colvec=1;
    chkdata=chkdata';   %forces everything to have the data down the rows of chkdata
    basedata=basedata';
    schk=size(chkdata);
else    colvec=0;   end
if all(sb==1)   basedata=basedata*ones(schk(1),1);  end
sb=size(basedata);

if sb(1)~=schk(1)   error(['Have ' num2str(sb(1)) ' baseline values for ' num2str(schk(1)) ' data series. These numbers need to match; fix dimensions of chkdata and basedata!']); end

%check other inputs
if nargin<8 || isempty(belowflag) belowflag=0;   end
if nargin<7 || isempty(usebasemax)   usebasemax=0;   end
if nargin<6 || isempty(nrels2)     nrels2=6;   end
if nargin<5 || isempty(nrels)     nrels=2;   end
if nargin<4 || isempty(pcton)     pcton=1.00;   end
if nargin<3 || isempty(nonsamps)     nonsamps=50;   end
if nonsamps<=0  error(['In findonset nonsamps input is ' num2str(nonsamps) '; Must be > 0']);    end
nonsampsg=ceil(nonsamps*pcton);
if size(nrels,1)==1     nrels=nrels';   end
if size(nrels,1)==1     nrels=nrels*ones(schk(1),1);   end

if sb(2)==1    
    cutoffval=basedata;
    cutoffval2=basedata;
else
    if usebasemax           %These takes nrels times the diff from the max and mean of basedata, and adds that to teh mean of basedata to get the cutoffval...
        cutoffval=nrels.*(max(basedata,[],2)-mean(basedata,2))+mean(basedata,2);    %I'm not sure if this would work if belowflag is set to 1, but don't worry about that for now... 090512
        cutoffval2=nrels2.*(max(basedata,[],2)-mean(basedata,2))+mean(basedata,2);
    else
        cutoffval=nrels.*std(basedata,[],2)+mean(basedata,2);    %I'm not sure if this would work if belowflag is set to 1, but don't worry about that for now... 090512
        cutoffval2=nrels2.*std(basedata,[],2)+mean(basedata,2);
    end
end

for isig=(1:schk(1))
    if belowflag    
        ontimes=find(chkdata(isig,:)<=cutoffval(isig)); 
        ontimes2=find(chkdata(isig,:)<=cutoffval2(isig));
    else
        ontimes=find(chkdata(isig,:)>cutoffval(isig)); 
        ontimes2=find(chkdata(isig,:)>cutoffval2(isig));
    end
    is=1;   %need to make sure on dur is met
    found=0;
    while is+nonsampsg-1<length(ontimes) && ~found
        if ontimes(is+nonsampsg-1)-ontimes(is)<=nonsamps-1   %This is the amount of total samples that could have been obtained between the times from the first and last sample covering the total amount of onsamples needed to registered over on dur in order to consider the onset to have been found
            %Still need to check that cutoffval2 is reached at least once
            
            %find out when the next gap in on times is, and find out if there any ontimes2 between now and then     
            FirstOnGap=find( diff(ontimes(is:end) )>1,1,'first' )+is-1;
            if isempty(FirstOnGap);     FirstOnGap=length(ontimes);     end
            endPer=ontimes(FirstOnGap);                                
            if any( isbetween( ontimes2,[ontimes(is) endPer]) )
                found=1;
            else
                is=FirstOnGap+1;  %For speed, skip to the next onset period if the larger threshhold wasn't reached during this one
            end
        else is=is+1;   
        end
    end
    if found    onsamp(isig,1)=ontimes(is);
    else    onsamp(isig,1)=NaN;   end
end

%shift output back to match the way input was
if colvec   onsamp=onsamp';     end