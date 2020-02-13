function todo=remueve_blinks_y_sacadas(todo)
% pone nan en todos los samples que ocurren dentro de un blink o sacada
% pupilsize=todo.samples(:,4);


if strcmp(todo.modo,'RTABLE') | strcmp(todo.modo,'MTABLE') %si es remoto o monocular
    todo=remueve_eventos(todo,todo.lesac,2:4);% saco sacadas left
    todo=remueve_eventos(todo,todo.resac,2:4);% saco sacadas right
    todo=remueve_eventos(todo,todo.lebli,2:4);% saco blinks left
    todo=remueve_eventos(todo,todo.rebli,2:4);% saco blinks right
elseif strcmp(todo.modo,'BTABLE') %si es binocular    
    if strcmp(todo.ojo,'RIGHT')
        todo=remueve_eventos(todo,todo.resac,2:4);% saco sacadas right
        todo=remueve_eventos(todo,todo.rebli,2:4);% saco blinks right
    elseif strcmp(todo.ojo,'LEFT')
        todo=remueve_eventos(todo,todo.lesac,2:4);% saco sacadas left    
        todo=remueve_eventos(todo,todo.lebli,2:4);% saco blinks left
    elseif strcmp(todo.ojo,'BOTH')
        todo=remueve_eventos(todo,todo.lesac,2:4);% saco sacadas left    
        todo=remueve_eventos(todo,todo.lebli,2:4);% saco blinks left
        todo=remueve_eventos(todo,todo.resac,5:7);% saco sacadas right
        todo=remueve_eventos(todo,todo.rebli,5:7);% saco blinks right
    else
        disp('OJO! no reconozco el ojo!')
    end    
    
    
end


end


function todo=remueve_eventos(todo,eventos,indremove)
% % saco eventos (puede ser blinks o sacadas) y los indremove pueden ser 2:4
% (ier ojo) o 5:7 (2do ojo) 
tiempo=todo.samples(:,1);
currevt=1;
i=1;
if isempty(eventos)
    return
end
%numel(tiempo)
while i<numel(tiempo)
    while tiempo(i)<eventos(currevt,1) && i<numel(tiempo);
        i=i+1;
    end
    startevt=i;
    while tiempo(i)<eventos(currevt,2)&& i<numel(tiempo);
        i=i+1;
    end
    endevt=i;
    todo.samples(startevt:endevt,indremove)=nan;     
    currevt=currevt+1;
    if currevt>size(eventos,1);
        break;
    end
end
end