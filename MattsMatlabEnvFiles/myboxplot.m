function myboxplot(Data,Labels,axh)
%function myboxplot(Data,Labels,axh)
%
% Inputs:
%   Data-   a 1 x c cell array of data. It's asusmed that within ecah cell
%           is just a 1d numeric vector of data.
%   Labels- a 1 x c cell array of the labels to use with the plot
%   axh-    (optional) the handle of the axes to create the plot on. If not
%           entered, the defult option is to create a new figure and plot
%           teh box plot in that

%AddTHplot(NSm,NSv,TrialLabels);

if nargin<3 || isempty(axh)
    figure;
    axes;
else        axes(axh)
end


%Find out number of columns
ncols=length(Data);

%pad labels with spaces so they are all an even number of letters
nlets=0;
for ic=1:ncols    nlets=max(nlets,length(Labels{ic}));  end
for ic=1:ncols    
    NLabels{ic}(1:nlets)=' ';
    NLabels{ic}(1:length(Labels{ic}))=Labels{ic};
end

%Move data into one long vector, with grouping variable G
X=[];
G=[];
for ic=1:ncols 
    X=[X; Data{ic}];
    G=[G; repmat(NLabels{ic},length(Data{ic}),1)];
end

%call matlab's boxplot function
boxplot(X,G,'notch','on')