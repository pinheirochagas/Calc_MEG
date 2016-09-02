function RGBout = myjet(colornumber,ncmapcolors)
% create matlab's jet colormap, with a few adjustments based on teh size
% desired.
%
% colornumber can be a scalar to get the RGB values for a single color, or
% it can be a group of numbers to get multiple color rgb values. For
% example, myjet(1:nmapcolors,nmapcolors) will return the entire colormap.

cmap=jet(ncmapcolors);

if ncmapcolors==1
    cmap(1,:)=[0 0 0.6];
elseif ncmapcolors==3
    cmap(end,:)=[1 0.5 0];
elseif ncmapcolors==4
    cmap(3,:)=[0.5 1 0.5];
    cmap(4,:)=[1 0.5 0];
else
    if ncmapcolors>5
        cmap(1,:)=[0 0 0.6];
    end
    if ncmapcolors>6
        cmap(end,:)=[0.6 0 0];
    end
end

RGBout=cmap(colornumber,:);

