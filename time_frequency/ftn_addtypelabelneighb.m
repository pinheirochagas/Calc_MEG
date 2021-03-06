function data=ftn_addtypelabelneighb(data)

% load labels per sensor type for plotting each sensor type
load('typelabel.mat');
% load neighbour sensors configuration (independently from channel
% selection, the magnetometers layout is loaded, as channel position is the
% same for the three types of sensors).
load('neuromag306mag_neighb.mat');

% add labels per sensor type for plotting each sensor type
data.typelabel=typelabel;

% add neighbours for Fieldtrip cluster-based stats
data.neighbours=neighbours;

end

