function [CdfOut,Centers] = myCdf(Data,BinWidth,useZeroMin,graphflag,useCA)
%
% Begun on 080315 by Matt Nelson. Calls myPdf with the same options and 
%   then integrates the result.
%
%   Below from myPdf
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

[PdfOut,Centers] = myPdf(Data,BinWidth,useZeroMin,graphflag,useCA);
if length(PdfOut)==1
    CdfOut=cumsum(PdfOut{1});
else
    for ipdf=1:length(PdfOut)
        CdfOut{ipdf}=cumsum(PdfOut{ipdf});
    end
end