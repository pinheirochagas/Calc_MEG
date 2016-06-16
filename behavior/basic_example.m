addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/analyses/'
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/results/VSA/sub12/'


close all
%%load data
filename='sub121v.asc';
data=analiza_datos(filename);

% data=interpola_blinks_y_sacadas(data);
data=remueve_blinks_y_sacadas(data);

% 
screenDim = [1024 768];

%% fixations on the screen
figure(1);clf
plot(data.samples(:,2),data.samples(:,3), 'o')
xlabel('posx')
ylabel('posy')

xlim([0 screenDim(1)])
ylim([0 screenDim(2)])

% set(gca,'YDir', 'Reverse')

hold on
plot([screenDim(1)/2 screenDim(1)/2], [0 screenDim(2)], 'r')
plot([0 screenDim(1)], [screenDim(2)/2 screenDim(2)/2], 'r')
% 
%% a basic heatmap
figure(2)
[out , C]=hist3([data.samples(:,2),data.samples(:,3)],[100 100]);
image(C{1},C{2},out')
xlabel('posx')
ylabel('posy')


xlim([0 1024])
ylim([0 768])

hold on
plot([screenDim(1)/2 screenDim(1)/2], [0 screenDim(2)], 'r')
plot([0 screenDim(1)], [screenDim(2)/2 screenDim(2)/2], 'r')


768/2

data.samples(1:10,:)


max(data.samples(:,2))
min(data.samples(:,2))

