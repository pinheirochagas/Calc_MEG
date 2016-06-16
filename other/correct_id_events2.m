n = 42
% retrieve list of events
all = []
count = 1
for i=1:n
    for t = 1:length(events(1,i).times);
        all(count,2)= str2double(events(1,i).label);
        all(count,1)= events(1,i).samples(t);
        count = count + 1
    end
end
% sort by onset
a = sortrows(all,1);
% python notation
a(:,2) = a(:,2) - 1;

%% delete confounds

    % sub1 run6
    a(14:end,2) = a(14:end,2) - 64;
    a(any(a==-1,2),:)=[];
    
    % sub1 run7
    a(38:302,2) = a(38:302,2) - 64;
    a(any(a==-1,2),:)=[];
    
    % sub8 run1
    a(any(a==2047,2),:)=[];
    a(:,2) = a(:,2) - 2048;



%% save
new = a;

clearvars -except new events
events2 = events

%%
lab = num2str(unique(new(:,2))+1);
length(lab)

%%

new2 = sortrows(new,2);

for i=1:42;
    
    events2(1,i).label = num2str(events2(1,i).label);
    a = str2double(events2(1,i).label)
    tmp = new2(any(new2==a-1,2),:)
    events2(1,i).samples = tmp(:,1)'
    events2(1,i).times = tmp(:,1)'/1000
    
end 

for i=1:42;
    events2(1,i).epochs = ones(1,length(events2(1,i).samples))
end 




