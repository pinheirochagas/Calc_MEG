function [Inds,curHist]=GetHistInds(data,edges)
%function Inds=GetHistInds(data,edges)
%
% Sorts the data into bins with edges given by edges, and returns the
% binnumber each element of data was sorted into, with a zero indicating
% that the corresponding value of data was not found to be between any two
% points in data. Also reports the histogram value for number of counts for
% each bin in the second output arugment
%
% data(i) will be sorted into bin k if EDGES(k) <= X(i) < EDGES(k+1).
%
% edges is assumed to be in ascending order, and will be flipped if it's
% not.
%
% This uses a while loop, and should run quicker if the data is already
% sorted
% 
% right now both data and edges are assumed to be 1d vectors.

if edges(2)<edges(1);        edges=fliplr(edges);        end
Inds=repmat(0,size(data));
curHist=repmat(0,1,length(edges)-1);

id=1;
nd=length(data);
ibn=1;
nbns=length(edges)-1;
while id<nd;
    if data(id)>=edges(ibn) && data(id)<edges(ibn+1)
        Inds(id)=ibn;
        curHist(ibn)=curHist(ibn)+1;
    else
        binFound=0;
        while ~binFound
            if data(id)>=edges(ibn) && data(id)<edges(ibn+1)
                Inds(id)=ibn;
                curHist(ibn)=curHist(ibn)+1;
                binFound=1;
            elseif data(id)<edges(ibn)
                if ibn>1
                    ibn=ibn-1;
                else
                    binFound=1;
                end
            else
                if ibn<nbns
                    ibn=ibn+1;
                else
                    binFound=1;
                end
            end
        end
    end
    
    id=id+1;
end