%FigPrintToFile.m
%
% this code courtesy of Seabstian Marti

% printing commands
savepath=[pwd '/results/'];
savename=([savepath 'fig1.tif']);

set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 4.75 3.75]) % choose here the size of the figure
ppos = get(gcf,'PaperPosition');
su = get(gcf,'Units');
pu = get(gcf,'PaperUnits');
set(gcf,'Units',pu);
spos = get(gcf,'Position');
set(gcf,'Position',[spos(1) spos(2) ppos(3) ppos(4)])
set(gcf,'Units',su)

%print(gcf, '-r300', '-dtiff', savename); % 300 ppi resolution