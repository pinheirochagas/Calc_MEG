function RGBout = mycolors(colornumber_all,cmapname,ncmapcolors)
% Outputs the RGB values in a 1x3 row vector associated with the
% custom set color designed by Matt given an input number. These
% numbers are based on but are not identical to the colors
% that matlab uses when adding multiple new plots to an axis at once,
% and are different than the 'rgbmcyk' colors set as plotting
% options for color in matlab.
%
% See matlabcolordefs for the RGB values associated with 'rgbmcyk'
% strings in plots.

% MJN: 140212 Old code for printflag- for colors taht semed good on The Andersen lab printer
% commenting this code- and that option, but levaing it as a reference
%if nargin<2 printflag=0; end
%if printflag
%    printconvert=[1 5 6 12 15 2 3 4 7 8 9 10 11 13 14];
%    colornumber=printconvert(colornumber);
%end

if nargin<2 || isempty(cmapname)   % A typical entry for cmapname would be 'jet' for example
    
    numcolors=14;
    nc=length(colornumber_all);
    RGBout=zeros(nc,3);
    for ic=1:nc
        colornumber=colornumber_all(ic);
        if mod(colornumber-1,numcolors)+1==1
            RGBout(ic,:) = [0 0 0]; %Black
        elseif mod(colornumber-1,numcolors)+1==2
            RGBout(ic,:) = [0 0 1]; %Blue
        elseif mod(colornumber-1,numcolors)+1==3
            RGBout(ic,:) = [0 .5 0]; %Medium Green, much sexier than the bright green for plot option 'g' which is RGB value [0 1 0]
        elseif mod(colornumber-1,numcolors)+1==4
            RGBout(ic,:) = [1 0 0]; %Red
        elseif mod(colornumber-1,numcolors)+1==5
            RGBout(ic,:) = [0 .75 .75]; %Teal, a hell of lot better than cyan
        elseif mod(colornumber-1,numcolors)+1==6
            RGBout(ic,:) = [.75 0 .75]; %Purple
        elseif mod(colornumber-1,numcolors)+1==7
            RGBout(ic,:) = [.75 .75 0]; %Marigold
        elseif mod(colornumber-1,numcolors)+1==8
            RGBout(ic,:) = [.5 .5 .5]; %Grey
        elseif mod(colornumber-1,numcolors)+1==9
            RGBout(ic,:) = [1 0 1]; %magenta
        elseif mod(colornumber-1,numcolors)+1==10
            RGBout(ic,:) = [1 .6 .6]; %pink
        elseif mod(colornumber-1,numcolors)+1==11
            RGBout(ic,:) = [.75 0 0]; %dark red
        elseif mod(colornumber-1,numcolors)+1==12
            RGBout(ic,:) = [1 .5 0]; %orange
        elseif mod(colornumber-1,numcolors)+1==13
            RGBout(ic,:) = [0 1 0]; %bright green as a last resort
        elseif mod(colornumber-1,numcolors)+1==14
            RGBout(ic,:) = [0 1 1]; %cyan as a last resort
        elseif mod(colornumber-1,numcolors)+1==15
            RGBout(ic,:) = [1 1 0]; %yellow
        end
    end
    
else
    if nargin<3 || isempty(ncmapcolors);    ncmapcolors=6;      end
    %%% a fix so that matlab pushes the extreme colors to the edge of the colormap, which I think is better...
    % if colornumber==1 || colornumber==ncmapcolors
    %     nmapcolors=1024;
    % end
    
    eval( ['cmap=colormap(' cmapname '(' num2str(ncmapcolors) '));'] )
    RGBout=cmap(colornumber,:);
end


