function [DataOut,Centers,Inds] = myHist2DSerial(Data,BinWidth,SpecMin,SpecMax,Dim,graphflag,useCA,AddCB)
%
% Begun on 100917 by Matt Nelson to apply myHist.m simultaneously to a 
% group of data samples of teh same size entered in a 2D matrix in Data.
% Code functionality is otherwise the same as myHist.
%
% ... it turns out matlab's hist function can do this without me needing to
% use a for loop... which is good
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
%       Dim:    


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

if nargin<7 || isempty(AddCB);    AddCB=1;  end
if nargin<7 || isempty(useCA);    useCA=0;  end
if nargin<6 || isempty(graphflag);    graphflag=1;  end
if nargout==0 && ~graphflag
    disp('nargout==0 and no graphflag, so nothing done in myHist2DSerial')
    return
end
%Other graph options- at this point just default Params   
numYTicks=5;

if nargin<5 || isempty(Dim);    Dim=1;  end
if nargin<4 || isempty(SpecMax);    SpecMax=max(max(Data));         end
if nargin<3 || isempty(SpecMin);    SpecMin=min(min(Data));         end
    
if Dim>2
    error(['Dim is: ' num2str(Dim) '. Must be 2 or less; functionality for greater than 2 dims not written yet.'])
elseif Dim==2   %adjust the input so that we know that the series variables are in Dim2, and the dim to take the histogram across is in Dim 1 (This makes the code much easier to write)
    Data=Data';         %... and as it turns out this is needed by Mtalab's hist function which works down the columns    
end
nS=size(Data,2);

if nargin<2 || isempty(BinWidth);    BinWidth=( SpecMax-SpecMin  )/20;    end

if SpecMin==SpecMax
    warning(['In myHist, Can''t do hist. All values in Data are the same, and equal to: ' num2str(Data(1))])
    if graphflag
        BinWidth=0.05;  %done for p-value plots...
        bar(SpecMin,sum(Data==SpecMin),BinWidth)
    end
    return
elseif isempty(Data)
    warning(['In myHist, input Data is empty. Can''t do hist.'])
    return
end
        

%round to lowest val within BinWidth for histogram
MinCenter =SpecMin;     %round(SpecMin/BinWidth)*BinWidth;
MaxCenter =round( (SpecMax-SpecMin)/BinWidth )*BinWidth + MinCenter;
Centers =[MinCenter:BinWidth:MaxCenter];
nCen=length(Centers);

%DataOut=repmat(0,nCen,nS);
%for iS=1:nS    % ... it turns out matlab's hist function can do this without me needing to use a for loop... which is good    
%    DataOut(:,iS)=hist(Data(:,iS),Centers);
%end
DataOut=hist(Data,Centers);

if graphflag
    if ~useCA
        figure
        ah=axes;
    else
        ah=gca;
    end
    imagesc(DataOut);
    axis xy
    if AddCB
        colorbar
    end
    
    Yind=round(linspace(1,nCen,numYTicks));    
    Yvals=(Yind-1) *BinWidth + Centers(1);
    %Yind(1)=.5;
    
    set(ah,'YTick',Yind);
    set(ah,'YTickLabel',Yvals);    
end      
        
if nargout>2
    Inds=ones(size(Data));
    for ic=2:length(Centers)
        Inds(Data>Centers(ic)-BinWidth/2)=ic;
    end
end

if Dim==2   %transpose back if needed
    DataOut=DataOut';
    if nargout>2
        Inds=Inds';
    end
end


