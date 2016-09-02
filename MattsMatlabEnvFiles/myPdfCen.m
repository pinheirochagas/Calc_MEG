function [PdfOut,Centers] = myPdfCen(Data,BinWidth,useZeroMin,graphflag,useCA)
%
% Begun on 080305 by Matt Nelson, adjusted from earlier myPdf function. The
% main difference between this and myPdf is that instead of teh Bin 

%to makes a quick pdf of the data input to
% it using parameters specified. Returns, and optionally graphs the data
% with specifice dprecision set in binwdith. Like myHist, only it 
% normalizes each value by the total amount of datapoints to give a 
% post-hoc probability, and it it supports multiple input variables to 
% graph in each input cell of Data.
%
% Last modified 060404 by Matt Nelson
%
% INPUTS:
%       Data: 1D cell array or 1D matrix of data you want a pdf histogram
%           of. If a 1D cell array, each cell should contain a 1D array of
%           data for the given variable.
%       Binwidth: Specificed width of bins. Default is 1
%       useZeroMin: Default is 1 which includes 0 as the min. bin center in
%            the pdf. You can set it to 0 to use the minimum point of the 
%            data as the min. bin center rounded to the nearest multiple of
%            BinWidth. Center of Max Bin is always set to the maximum in 
%            the data, rounded to the nearest multiple of BinWidth.
%       graphflag: 0 or 1 if you do or do not want a bar plot made in a new
%           figure window. Default = 1
%       useCA: set to 1 if you want to use current axis (defined before the
%           function is called) in the graph this procudes. Default is 0, 
%           which creates a new figure.
%
% Outputs:
%       PdfOut: # of occurences per bin in data, should follow
%       Centers: Centers of bins used in pdf
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<5|isempty(useCA)
    useCA=0;
end
if nargin<4|isempty(graphflag)
    graphflag=1;
end
if nargin<3|isempty(useZeroMin)
    useZeroMin=1;
end
if nargin<2|isempty(BinWidth)
    BinWidth=1;
end

if ~iscell(Data)
    [r,c]=size(Data);
    if c>r  %then put each row of Data into a cell
        temp=mat2cell(Data,ones(1,c));
    else    %then put each column of Data into a cell
        temp=mat2cell(Data',ones(1,r));
    end
    clear Data;
    Data=temp;
end

numPdfs=length(Data);
MaxCenter=0;
MinCenter=0;
for ip=1:numPdfs
    if ~isempty(Data{ip})
        DataMax{ip}=max(Data{ip});
        if useZeroMin==1;
            DataMin{ip}=[0];
        else
            DataMin{ip}=min(Data{i});
        end
        MaxCenter=max([MaxCenter DataMax{ip}]);
        MinCenter=min([MinCenter DataMin{ip}]);
    end
end
Centers=[MinCenter:BinWidth:MaxCenter];

if graphflag
    if ~useCA   
        figure
    end
    hold on
end   

crappycolors=['brgmcky'];
for ip=1:numPdfs
    if ~isempty(Data{ip})
        DataHist{ip}=hist(Data{ip},Centers);
        Num{ip}=sum(DataHist{ip});
        DataHist{ip}=hist(Data{ip},Centers);
        PdfOut{ip}=DataHist{ip}/Num{ip};
        if graphflag
            plot(Centers,PdfOut{ip}, crappycolors(mod(ip,length(crappycolors))));
        end
    end
end