function [AllDataOut,Centers,Inds] = myHistWSig(AllData,SigData,BinWidth,useZeroMin,graphflag,useCA)
%
% SigData has the same form as AllData, giving the values for all the data
% points that were considered to be significant
%
% Modified from myHist.m
% myHist.m was made to create quick histograms a certain way
% using parameters specified. Returns, and optionally creates a histogram
% of the input data, with specified Binwidth
%
% Last modified 060404 by Matt Nelson
%
% INPUTS:
%       Data: 1D matrix of data you want a histogram of
%       Binwidth: Specificed width of bins. default is the width of the
%               data range divided by 20
%       useZeroMin: Set to 1 if you want to include 0 as the min. bin center in the
%            histogram, which assumes the minimum center is the minimum 
%            point of the data rounded to the nearest multiple of binwidth.
%            Center of Max Bin is always set to the maximum in the data, 
%            rounded to the nearest multiple of binwidth. Default is 0
%       graphflag: 0 or 1 if you do or do not want a bar plot made in a new
%           figure window. Default = 1
%       useCA: set to 1 if you want to use current axis (defined before the
%           function is called) in the graph this procudes, or set to 0 to  
%           create a new figure. Default is 0.
%
% Outputs:
%       DataOut: # of occurences per bin in data
%       Centers: Centers of bins used in histogram
%       Inds:   The indices in centers falling in each data bin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<6 || isempty(useCA)    useCA=0;  end
if nargin<5 || isempty(graphflag)    graphflag=1;  end
if nargin<4 || isempty(useZeroMin)    useZeroMin=0;    end
AllDataMin=min(AllData);    %NaN's are automatically ignored by matlab in these functions
AllDataMax=max(AllData);
if nargin<3 || isempty(BinWidth)    BinWidth=(AllDataMax-AllDataMin)/20;    end
if nargin<2     SigData=[];     end

if min(AllData)==max(AllData)     
    warning(['In myHist, Can''t do hist. All values in AllData are the same, and equal to: ' num2str(AllData(1))])
    return
elseif isempty(AllData)
    warning(['In myHist, input AllData is empty. Can''t do hist.'])
    return
end
        

%round to lowest val within BinWidth for histogram
if useZeroMin
    MinCenter=0;
else
    MinCenter =round(AllDataMin/BinWidth)*BinWidth;
end
MaxCenter =round(AllDataMax/BinWidth)*BinWidth;
Centers =[MinCenter:BinWidth:MaxCenter];

if graphflag
    if ~useCA
        figure
    end
    if nargout==0
        hist(AllData,Centers);    %without output arguments, it plots this automatically                
    else  
        AllDataOut=hist(AllData,Centers);
        bar(Centers,AllDataOut);
    end
    
    tax=gca;
    h = findobj(tax,'Type','patch');
    set(h,'FaceColor','w');
    set(tax,'TickDir','out')
    
    hold on
    if ~isempty(SigData)
        hist(SigData,Centers);
        h = findobj(gca,'Type','patch');
        set(h(1),'FaceColor','k');
    end
else
    if nargout==0
        disp('nargout==0 and no graphflag, so nothing presented in myHist')
    else
        AllDataOut=hist(AllData,Centers);
    end
end

if nargout>2
    Inds=ones(size(AllData));
    for ic=2:length(Centers)    
        Inds(AllData>Centers(ic)-BinWidth/2)=ic;        
    end    
end