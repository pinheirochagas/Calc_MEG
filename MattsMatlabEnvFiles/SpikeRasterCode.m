%SpikeRasterCode.m
%
%   This whole program is just a comment reminding me of the nifty way to
%   create spike rasters in matlab. see below.
%
% line([(Raw(TaskRef).Spike{ind(ras)})'+bn(1); (Raw(TaskRef).Spike{ind(ras)})'+bn(1)],...
%     [ones(1,numspikes)*(tempypos+RasSpacing*(1-RasIntSpaceFrac)/2);... %Start ypos
%     ones(1,numspikes)*(tempypos-RasSpacing*(1-RasIntSpaceFrac)/2)],'Color',Mattscolordefs(iplot));

%Basically this is: 
%   line([xpos; xpos], [ypos1; ypos2])
%
%   where xpos and ypos are both row vectors... I imagine you could have
%   different xpos and ypos row vectors if you wanted to...