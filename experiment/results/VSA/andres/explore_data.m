
addpath /Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/VSA/EyeMMV-master


hist(todo.samples(:,2))
max(todo.samples(:,3))


data = [todo.samples(:,2) todo.samples(:,3) todo.samples(:,1)];


csvwrite('data.txt', data)


heatmap_generator('data.txt','fixation.bmp',0.0833,1024,768,5,3)