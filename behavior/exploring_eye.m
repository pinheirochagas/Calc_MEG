addpath('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/analyses/')

subjectID = 'andres'
% Select relevant messages (events)
cores = get(groot,'DefaultAxesColorOrder');
azul = cores(1,:);
verde = cores(5,:);
azulclaro = cores(6,:);
vinho = cores(7,:);
amarelo = cores(3,:);
rosa = [255 0 127]/255;
laranja = [255 128 0]/255;

tamanhoFonte = 18


for i=5:5
    todo = analiza_datos(sprintf('%s%i.asc',subjectID,i));
    
    % get invalid trials 
    
    filename = sprintf('run%i.csv',i);
    delimiter = ',';
    startRow = 2;
    formatSpec = '%*s%*s%*s%*s%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    Congruency = dataArray{:, 1};
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;

    array1 = 1:7:525;
    array2 = 5:7:525;
    array3 = sort([array1 array2]);
    todo.msguni = todo.msg(array3); 
    todo.msgtimeuni = todo.msgtime(array3);
    
    ntrials = 75;

    % crop data
    
    begin = todo.msgtimeuni(1);
    finish = todo.msgtimeuni(end)+100;
    
        
    times = todo.samples(find(todo.samples(:,1)==begin):find(todo.samples(:,1)==finish),1);
    xcoords = todo.samples(find(todo.samples(:,1)==begin):find(todo.samples(:,1)==finish),2);
    ycoords = todo.samples(find(todo.samples(:,1)==begin):find(todo.samples(:,1)==finish),3);
    cues = [todo.msgtimeuni(1:2:length(todo.msgtimeuni)), repmat(530,ntrials,1)];
    cues = cues(cues(:,1)>=begin|cues(:,1)<=finish,:);
    cuesinv = [cues(Congruency==1),repmat(530,length(cues(Congruency==1)),1)];
    sacc = [todo.lesac(:,1),repmat(527, length(todo.lesac(:,1)),1)];  
    sacc = sacc(sacc(:,1)>=begin & sacc(:,1)<=finish,:);
    blinks = [todo.lebli(:,1),repmat(mean([nanmean(todo.samples(:,2)) nanmean(todo.samples(:,3))]), length(todo.lebli(:,1)),1)];
    blinks = blinks(blinks(:,1)>=begin & blinks(:,1)<=finish,:); 
    
    set(figure, 'Position', [0 0 1400 800])

    plot(times,xcoords, 'Color', azul)
    hold on
    plot(times,ycoords,'Color', verde)
    plot(sacc(:,1),sacc(:,2),'o', 'Color', rosa)  
    plot(cues(:,1),cues(:,2),'o','Color', 'black')
    plot(cuesinv(:,1),cuesinv(:,2),'.','Color', 'black','markersize',20)
    plot(blinks(:,1),blinks(:,2),'o', 'Color', laranja)
    xlim([begin-10000,finish+10000])
    ylim([300 600])


    text(times(end,1)-40000,590,'horizontal movements','Color', azul, 'FontSize', tamanhoFonte);
    text(times(end,1)-40000,580,'vertical movements','Color', verde, 'FontSize', tamanhoFonte);
    text(times(end,1)-40000,570,sprintf('%i cues',ntrials),'Color', 'black', 'FontSize', tamanhoFonte);
    text(times(end,1)-40000,560,sprintf('%i saccades',length(sacc)),'Color', rosa, 'FontSize', tamanhoFonte);
    text(times(end,1)-40000,550,sprintf('%i blinks',length(blinks)),'Color',laranja, 'FontSize', 18);

    
    set(gca, 'FontSize', 16);
    xlabel('Time', 'FontSize', tamanhoFonte)
    ylabel('Coordinate', 'FontSize', tamanhoFonte)
    title(sprintf('%s block %i',subjectID,i), 'FontSize', tamanhoFonte)
    
    save2pdf(sprintf('eyetracker_%s_block%i.pdf',subjectID,i), gcf, 600) 
    close
end
