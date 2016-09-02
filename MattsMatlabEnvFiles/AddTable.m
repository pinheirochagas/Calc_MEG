function [thands,tabax]=AddTable(CellStrIn,AxPos,RowHeight,StartVPos,ColPos,AlignFlag)
%function handles=AddTable(CellStrIn,AxPos,RowHeight,StartVPos,ColPos,AlignFlag)
%
%   Will add a table of text to the current figure. Just text (for now), no
%   lines or anything fancy
%
%   INPUTS:
%       CellStrIn:  -a 2D (nr x nc) cell array of strings to add to the 
%                   table at each position. The first row corresponds to
%                   the highest row of the table. If a given cell is empty,
%                   no text is added for that location.
%       AxPos:      -The 1x4 (i.e. [left, bottom, width, height]) position 
%                   vector for the axes of the table, OR you can input a 
%                   scalar with an existing axes handle, and it will add 
%                   the table to that axis, its a scale Defaults to [0 0 1 1]
%       RowHeight:  -A scalar value of the height of each row, in 
%                   normalized units. Defaults to evenly spreading out the 
%                   rows across the table axes from the starting height, 
%                   i.e. [nr-1:-1:0]/(nr-1)*StartVPos
%       StartVPos:  -A scalar value of the height of the first row on the
%                   axes. Defaults to .85
%       ColPos:     -A vector for the position of each column. Defaults to
%                   evenly spacing out the columns, i.e.
%                   ([1:nc]*2-1)/(2*nc)
%       AlignFlag:  -How to align the text about each Column Position. -1 =
%                   left, 0 = center, 1 = right. Defaults to 0.
%
%   OUTPUTS:
%       thands:    -a nr x nc numeric array with handles for the text 
%                   object added at each corresponding position       
%       tabax:     -The handle for the table axis  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nr,nc]=size(CellStrIn);
thands=zeros(nr,nc);
if nargin<6|isempty(AlignFlag)  AlignFlag=0;    end
if nargin<5|isempty(ColPos)  ColPos=([1:nc]*2-1)/(2*nc);    end %evenly spaced
if nargin<4|isempty(StartVPos)  %this is the VPos for the top row
    %if nr>1    StartVPos=.85;    else   StartVPos=.5;   end
    if nr==1    StartVPos=0;    else    StartVPos=1-1/nr;   end
end
if nargin<3|isempty(RowHeight)  
    %RowHeight=[nr-1:-1:0]/(nr-1)*StartVPos;    %This would creat evenly Row Poss, not Row Heights
    if nr==1    RowHeight=1-StartVPos;      else    RowHeight=StartVPos/(nr-1);     end
end  %evenly spaced
if nargin<2|isempty(AxPos)  AxPos=[.1 .1 .8 .8];    end
RowPos=StartVPos-RowHeight.*[0:nr-1];

if length(AxPos)==1 
    axes(AxPos);
    tabax=AxPos;
else    tabax=axes('position',AxPos,'Visible','off'); end
if AlignFlag==1
    for ir=1:nr
        for ic=1:nc
            if ~isempty(CellStrIn{ir,ic})
                thands(ir,ic)=text(ColPos(ic),RowPos(ir),CellStrIn{ir,ic},'HorizontalAlignment','right');
            end
        end
    end
elseif AlignFlag==-1
    for ir=1:nr
        for ic=1:nc
            if ~isempty(CellStrIn{ir,ic})
                thands(ir,ic)=text(ColPos(ic),RowPos(ir),CellStrIn{ir,ic});
            end
        end
    end
else
    for ir=1:nr
        for ic=1:nc
            if ~isempty(CellStrIn{ir,ic})
                %disp([num2str(ir) ' ' num2str(ic)])
                if strcmp(class(CellStrIn{ir,ic}),'double')     CellStrIn{ir,ic}=num2str(CellStrIn{ir,ic}); end
                thands(ir,ic)=text(ColPos(ic),RowPos(ir),CellStrIn{ir,ic},'HorizontalAlignment','center');
            end
        end
    end
end