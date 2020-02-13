function [todo]=analiza_datos(ascfilename)
% Parser for the ASC file generated by edf2asc, into a Matlab structure
% [todo]=analiza_datos('mytest.asc') 
% [todo]=analiza_datos(ascfilename) 
% ascfilename: ascii filename (including extension)
% ascii file should be created by "edf2asc ascfilename", with default settings
%
%
%structure fields:
%             modo: mode: ('BTABLE'|'RTABLE'|'MTABLE'}
%              ojo: eye: {'BOTH'|'LEFT'|'RIGHT'}
%            srate: sampling rate: {250|500|1000}
%     driftcorrect: 2x2 matrix of drift correction
%      headerlines: number of lines in the header, before the beginning of the data
%           header: a cell array containing the header lines
%       fieldnames: some help lines containing the definitions of columns in samples, saccades, blinks and fixations
%          samples: Nsam x 4 or Nsam x 7 matrix containing all eye samples (see fieldnames)
%            resac: Nsac x 9 right eye saccades (see filenames) 
%            lesac: Nsac x 9 left eye saccades (see fieldnames)
%            refix: Nfix x 6 right eye fixations (see fieldnames)
%            lefix: Nfix x 6 left eye fixations (see fieldnames)
%            rebli: Nbli x 3 right eye blinks (see fieldnames)
%            lebli: Nbli x 3 left eye blinks (see fieldnames)
%          msgtime: Nmsg x 1 the times of the messages
%              msg: Nmsc x 1 cells with the text of the messages
%
% Diego Shalom (diegoshalom (at) gmail.com)
% Laboratorio de Neurociencia Integrativa
% Departamento de F�sica - Facultad de Ciencias Exactas y Naturales
% Universidad de Buenos Aires - Buenos Aires - Argentina
% Dec-2013


if nargin~=1
    disp('Parser for the ASC file generated by edf2asc, into a Matlab structure')
    disp('  [todo]=analiza_datos(''mytest.asc'')') 
    todo=[];
    return
end
    
    


if ~exist(ascfilename,'file')
    disp('Error: File not found.')
    todo=[];
    return
end

disp(['Analysis of file: ' ascfilename])



todo=[];
todo.headerlines=set_header_length(ascfilename) ;%look for header length
todo.header=lee_encabezado(ascfilename, todo.headerlines);
todo.modo=modo_eyelink(ascfilename,todo.headerlines);%look for eyelink mode
todo.ojo=busca_ojo(ascfilename,todo.headerlines);%look for tracked eye
todo.srate=busca_samplingrate(ascfilename,todo.headerlines);%look for sampling rate
todo.driftcorrect=busca_driftcorrect(ascfilename,todo.headerlines);

a=read_file_skip_header(ascfilename,todo.headerlines);

%column definitions of samples and eye events 
todo.fieldnames.fixations='<stime> <etime> <dur> <axp> <ayp> <aps>';
todo.fieldnames.saccades='<stime> <etime> <dur> <sxp> <syp> <exp> <eyp> <ampl> <pv>';
todo.fieldnames.blinks='<stime> <etime> <dur>';
todo.fieldnames.samplesmonoc='<time> <xp> <yp> <ps>';
todo.fieldnames.samplesbinoc='<time> <xpl> <ypl> <psl> <xpr> <ypr> <psr>';

[dataeventos datasamples]=separa_samples_eventos(a);

todo.samples =busca_samples(datasamples,todo.ojo);%samples

todo.resac=busca_eventos(dataeventos,'ESACC R');%eye events
todo.lesac=busca_eventos(dataeventos,'ESACC L');%eye events
todo.refix=busca_eventos(dataeventos,'EFIX R');%eye events
todo.lefix=busca_eventos(dataeventos,'EFIX L');%eye events
todo.rebli=busca_eventos(dataeventos,'EBLINK R');%eye events
todo.lebli=busca_eventos(dataeventos,'EBLINK L');%eye events
[todo.msgtime msgline]=busca_eventos(dataeventos,'MSG');
todo.msg=dataeventos(msgline);   
todo=remove_time_from_msg(todo);%as it is, the string of the messages include the time. here i remove it, lo leave only de the message

 save todo todo
end

function todo=remove_time_from_msg(todo)
%removes the time from todo.msg, leaving only the msg
for i=1:length(todo.msg)
    [A, count, errmsg, nextindex]=sscanf(todo.msg{i},'MSG%f');%todo esto para buscar nextindex
    %nextindex es el indice del caracter despues de leer MSG y un float
    todo.msg{i}=todo.msg{i}(nextindex+1:end);
end
end

function a=read_file_skip_header(archivo,S)
%abre el archivo llamado filename y mete todas las lineas de texto en la celda C
filename=archivo;
fid = fopen(filename);
C = textscan(fid, '%s','HeaderLines',S,'delimiter', '\n');
fclose(fid);
a=C{1};
end

function [dataeventos datasamples]=separa_samples_eventos(data)
    % saco las celdas que no son samples
    ind1=mystrmatch('E',data);%por ESACC, EFIX, EBLINK, y EVENTS
    ind2=mystrmatch('S',data);%por SSACC, SFIX, SBLINK, START y SAMPLES
    ind3=mystrmatch('M',data);%por MSG
    ind4=mystrmatch('P',data);%por PUPIL    
    ind5=mystrmatch('V',data);%por VPRESCALER
    ind6=mystrmatch('I',data);%por INPUT
    ind7=mystrmatch('B',data);%por BUTTON
    ind=setxor(1:length(data),[ind1;ind2;ind3;ind4;ind5;ind6;ind7]);
    
    dataeventos=data([ind1;ind2;ind3;ind4;ind5;ind6;ind7]);
    datasamples=data(ind);
end

function matriz =busca_samples(data,ojo)
try
    i=0;
    tic


    fprintf(1,'%d samples to process:\n  ',length(data));   
    
    if strcmp(ojo,'LEFT') | strcmp(ojo,'RIGHT') %si es remoto o monocular
        %no hago lo mismo que en binocular pues eso es mucho mas lento.
        matriz=nan(length(data),4);
        lengthstr=0;
        for i=1:length(data);            
            if mod(i,100000)==0;
                str=sprintf('%d00k...',i/100000);                
                for j=1:lengthstr
                    fprintf('\b')
                end
                fprintf('%s',str)
                lengthstr=length(str);
            end                         
            temp=sscanf(char(data(i)),'%f');
            if length(temp)==4
                matriz(i,:)=temp;
            elseif length(temp)==1
                matriz(i,:)=nan;
                matriz(i,1)=temp;
            end
        end
    elseif strcmp(ojo,'BOTH') %si es binocular
        matriz=nan(length(data),7);
        lengthstr=0;
        for i=1:length(data);
            
            
            if mod(i,100000)==0;
                str=sprintf('%d00k...',i/100000);                
                for j=1:lengthstr
                    fprintf('\b')
                end
                fprintf('%s',str)
                lengthstr=length(str);
            end                       
            
            sal=extrae_datos_linea_binoc(char(data(i)));
            matriz(i,:)=sal';
        end

    else
        disp('Modo desconocido')
        matriz=[];
        return
    end

    Index=find(isnan(matriz(:,1)));
    matriz(Index,:)=[];

    tiempo=toc;
    fprintf(1,'\n%d samples found in %2.2f seg.\nSpeed: %0.0f Samples/seg\n',length(matriz),tiempo,length(matriz)/tiempo);
catch ME
    sprintf('\n\nFallo en la linea %d, probablemente hiciste una recalibracion o driftcorrect al ratito de empezar.\nChequea el archivo asc en estas lineas.\n', i)    
    ME
    keyboard
end
    

end

function [matriz indices] = busca_eventos(data,event_name)


% we need to know the number of fields in each type of event
switch event_name
   case {'EFIX L','EFIX R' }
      numeros=6;%length of array if events are fixations
   case {'ESACC L','ESACC R'}
      numeros=9;%length of array if events are saccades
   case {'EBLINK L','EBLINK R'}
      numeros=3;%length of array if events are blinks
   case 'MSG'%length of array if events are msg
      numeros=1;
    otherwise
       disp('nose')       
end


indices=mystrmatch(event_name,data);
matriz=nan(length(indices),numeros);
try
for i=1:length(indices);
%    data{indices(i)}
    temp=sscanf(data{indices(i)},[event_name ' %f %f %f %f %f %f %f %f %f']);
    if length(temp)==numeros
        matriz(i,1:numeros)=temp(1:numeros);
    end
end
matriz(isnan(matriz(:,1)),:)=[];
catch ME
    ME
    keyboard
end
disp([num2str(length(indices)) ' events ' event_name ' found.'])    

end

function [coincidencias]=mystrmatch(string,data)
    coincidencias=[];
    deacuantos=200000;
    pos=0;
    contador=0;
    while pos<length(data);
        if (pos+deacuantos)>length(data)
            indices=(pos+1):length(data);
        else
            indices=pos+(1:deacuantos);
        end
        loqueagrego=pos+strmatch(string,data(indices));
        coincidencias=[coincidencias; loqueagrego];        
        pos=pos+deacuantos;
        contador=contador+1;
%        fprintf(1,'%d %d %d %d\n',contador,indices(1),indices(end),length(loqueagrego))
    end
        
% %esto anda pero es lento pues ejecuta strmatch 10millones de veces    
%     indices=[];
%     for i=1:length(data)
%         temp=data{i};
%         if strmatch(string,temp(1:length(string)))
%             indices(end+1)=i;    
%         end
%     end
%     coincidencias=indices;
end

function [texto]=lee_encabezado(filename, maxlines)
% lee las primeras maxlines lineas
% y devuelve yn array de celdas

linea=[];
tline=[];
fid=fopen(filename);
contador=0;
texto=[];
while isempty(ferror(fid)) && contador<maxlines %mientras no da fin de archivo
    contador=contador+1;
    tline = fgetl(fid);    %leo una linea del archivo
    texto{contador}=tline; %la pongo en una celda
end
fclose(fid);
end

function [linea tline]=busca_texto_en_archivo(filename, texts,maxlines)
% busca uno de los textos en el archivo, hasta un maximo de maxline lineas
% y devuelve numero de linea y texto de la linea encontrada
linea=[];
tline=[];
fid=fopen(filename);
contador=0;
while isempty(ferror(fid)) && contador<maxlines %mientras no da fin de archivo
    contador=contador+1;
    tline = fgetl(fid);    %leo una linea del archivo
    for i=1:length(texts)% para cada uno de los textos de busqueda
        if ~isempty(strfind(tline,texts{i})) %me fijo si aparece en la linea
%            disp([tline ])
            linea=contador; 
            fclose(fid);
            return %si parece cierro y me voy
        end
    end
%    disp([num2str(contador) tline])
end
fclose(fid);
if isempty(linea)
    tline=[];
end
end

function MODO=modo_eyelink(archivo,headerlines)
% se fija si es (M)onocular, (B)inocular o (R)emoto
    MODO=[];
    [linea textline]=busca_texto_en_archivo(archivo, {'ELCLCFG'},headerlines);
    if strfind(textline,'RTABLE')>0
        MODO='RTABLE';%remoto
    elseif  strfind(textline,'BTABLE')>0
        MODO='BTABLE';%binocular
    elseif strfind(textline,'MTABLE')>0
        MODO='MTABLE';%monocular
    end
    disp(['Mode: ' MODO]);    
end

function ojo=busca_ojo(archivo,headerlines)
%busca que ojo se utilizo
    [linea textline]=busca_texto_en_archivo(archivo,{'START'},headerlines);
    ojo=[];
    if isempty(linea)
        ojo=nan;        
    else
        derecho=strfind(textline,'RIGHT');      
        izquierdo=strfind(textline,'LEFT');
        if ~isempty(derecho) && ~isempty(izquierdo)
            ojo='BOTH';
        elseif ~isempty(derecho) && isempty(izquierdo)
            ojo='RIGHT';
        elseif isempty(derecho) && ~isempty(izquierdo)
            ojo='LEFT';
        else
            ojo='??';
            disp('ojo no reconocido')
        end
    
    end
    disp(['Eye: ' ojo]);    
end

function srate=busca_samplingrate(archivo,headerlines)
%busca que ojo se utilizo
    [linea textline]=busca_texto_en_archivo(archivo,{'RATE'},headerlines);
    ojo=[];
    if isempty(linea)
        srate=[];
    else
        posicion=strfind(textline,'RATE');
        srate=sscanf(textline(posicion+4:end),'%f');
    end
    disp(['Sampling Rate: ' num2str(srate)]);
end

function driftcorrect=busca_driftcorrect(archivo,headerlines)
%devuelve el primer drift correct que encuentra, en formato
%[[dcxl dcyl] 
% [dcxr dcyr]]

    [linea textline]=busca_texto_en_archivo(archivo, {'DRIFTCORRECT LR LEFT' 'DRIFTCORRECT L LEFT'},headerlines);        
    if isempty(linea)
        driftcorrectleft=[nan; nan];
    else
        posicion=strfind(textline,'deg.');
        driftcorrectleft=sscanf(textline(posicion+4:end),'%f,%f');
    end
    
    [linea textline]=busca_texto_en_archivo(archivo, {'DRIFTCORRECT LR RIGHT' 'DRIFTCORRECT R RIGHT'},headerlines);        
    if isempty(linea)
        driftcorrectright=[nan; nan];
    else
        posicion=strfind(textline,'deg.');
        driftcorrectright=sscanf(textline(posicion+4:end),'%f,%f');
    end
    driftcorrect=[driftcorrectleft driftcorrectright]';
end

function sal=extrae_datos_linea_binoc(entrada)
try
    str=entrada;    
    res{1}=sscanf(str,'%f'); %optimo para todos los datos
    if length(res{1})==7% si esta conversion saca 7 numeros entonces ya esta
        sal=res{1};
        return% devuelvo lo que obtuve
    end
    %sino, hago una busqueda para ver cual de todos es el que debe usarse
    
    res{2}=sscanf(str,'%f .  . %f . . %f'); %optimo para ningun dato
    res{3}=sscanf(str,'%f %f %f %f . . %f'); %optimo para solo izdo
    res{4}=sscanf(str,'%f . .  %f %f %f %f'); %optimo para solo dcho
    long=[length(res{1}) length(res{2}) length(res{3}) length(res{4})];
    m=find(long==max(long),1);
    switch m
        case 1
            sal=res{1};
        case 2
            sal=[res{2}(1);nan(6,1)];
        case 3
            sal=[res{3}(1:4);nan(3,1)];
        case 4
            sal=[res{4}(1);nan(3,1);res{4}(3:5)];
    end
    sal=sal';
catch ME
    ME
    disp('error... chequea la ultima linea de tu archivo asc. posiblemente tiene datos truncados...')
    keyboard
end
end

function S=set_header_length(archivo)
%busca los textos "SAMPLES\tGAZE" o "EVENTS\tGAZE" o "SYNCTIME" en el asc para ver desde donde empezar
[linea]=busca_texto_en_archivo(archivo, {'SAMPLES	GAZE' 'EVENTS	GAZE' 'SYNCTIME'},2000);
if isempty(linea)
    disp('Reached EOF and didn''t found any of corresponding texts')
    disp('Startline: 200')
    S=200; %defaulvalue...
else
    S=linea+15;
    disp(['Startline: ' num2str(S)])
end
end