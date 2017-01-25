clear
data = analiza_datos('samples_and_events_run3_leftEye.asc')

MSGS = {'TRIALID',...    messages to look for within each block
    'EVENTID',...
    'RESPID'};


message_searched = 'REF';            % message to search for marking the beginning of each block
block = 0;  % counter for blocks
BLOCK = [ ];
POS = [];
for count =1:size(data.msg,1)   % counter for time points
    
    message = data.msg{count};  % gets the message number "count"
    if findstr(message, message_searched)
        POS = [POS count]; % if REF appears, a new block: save the counter
    end
end


whos POS % number of blocks
%%

for block = 1:length(POS)                                  % for all blocks
    block
    
    if block ==length(POS)
        Trial = {data.msg{POS(block)+1:end}};               
        Time =  data.msgtime(POS(block)+1:end);     
    else
        Trial = {data.msg{POS(block)+1:POS(block+1)}};         % get the messages from begining to end of block
        Time =  data.msgtime(POS(block)+1:POS(block+1));       % and the time oclcf each message
    end
    
    for C=1:8                                              % for each trial within the block
        ev = 0;
        for m = 1:length(MSGS)                             % and each possible message (trial, event, response)
            message = [MSGS{m},' ',num2str(C)];
            for tr =1:length(Trial)                        % finds the position of that message within the block
                D = findstr(Trial{tr},message);
                if D,break,end
            end
            
            if not(isempty(D))                             % if there is such a message (sometimes there is no response)
                ev = ev + 1;
                Block(block).trial(C).event(ev).type = message;         % saves message type
                Block(block).trial(C).event(ev).starttime = Time(D);    % saves start time
                
                ini = find(data.samples(:,1) == Time(D));                
                fin = find(data.samples(:,1) == Time(D+1));
                
                Block(block).trial(C).event(ev).pupilsize = data.samples(ini:fin ,2); % saves X
                Block(block).trial(C).event(ev).pupilsize = data.samples(ini:fin ,3); % saves Y
                Block(block).trial(C).event(ev).pupilsize = data.samples(ini:fin ,4); % saves pupil size
            end
        end
    end
end
save('filename.mat','Block')





