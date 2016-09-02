function LFPSpecPlot(day,datapath,bn,tapers,dn,fk)
% function LFPSpecPlot(day,datapath,bn)
% 
%   INPUTS: 
%       DAY =   The recording day to look for.
%             Note that day is 1 six digit string in month,day year format.
%             i.e. for May 4th, 2006, day is '050406'
%       DATAPATH = The path for the folder in which to look for all the
%           .mat files that have DAY in their name somewhere
%       BN  =   The time bin around the reference event you you would like
%           to analyze. In form [starttime endtime]
%           Defaults to [-400 800]
%       TAPERS  =   Typically in [N,W] form, where N is the window length in seconds,
%                   and W is the frequency resolution, in Hz
%                   Defaults are .4 for N, and 5 for W
%                   
%                   Can also accept [N,P,K] form, where P=N*W, and K is the
%                   number of tapers you want to keep, starting with the
%                   first;
%
%                   Can also accept [K,TIME] form where the tapers are already
%                   calculated, with each taper you want to use down each
%                   column. Useful if you want to use this sliding window code for
%                   non-Slepian tapers, like Gaussian or rectangular, etc.
%	    DN		=  Amount to slide window each time sample. (In s)
%			       	Defaults to 12 ms;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,200] unless 200 > sampling/2, in which case
%			   	it defaults to [0,SAMPLING/2]
%
% This was originally created for use with the impedance data, but can
% easily be changed to apply to other data
%
% Created by MJN 060513 (May 13th, 2006)

EvList={'Target_','Sacc_of_interest'};
AltEvList={'','Saccade_'};
chanlist=[1 2 3];    %tell the program how many electrodes you want to look at
sampling=250; %Hz
nch=length(chanlist);
nevts=length(EvList);

if nargin<6|isempty(fk) fk=sampling/2;  end
if nargin<5|isempty(dn) dn=.012; end %In seconds. 

if nargin<3|isempty(bn) bn=[-400 800]; end %In ms. 
if nargin<2|isempty(datapath)
    datapath='/home/nelsonmj/Desktop/MatlabWork/ImpedanceData/';
end
cd([datapath day])

if nargin<4|isempty(tapers)
    tapers(1) = .400; %This is N, the window length, in seconds
    tapers(2) = 5; %This is W, the frequency resolution, in Hz.
    
    %n = floor(nt./10)./sampling;
    %if nargin < 2 tapers = [n,3,5]; end  %Bijan's default within tfspec, perhaps useful for reference later    
end
if length(tapers) > 3
   N=size(tapers,1)/sampling; %gives window length in seconds
else
   N=tapers(1);
end

bn=[bn(1)-N/2*1e3,bn(2)+N/2*1e3];
presamps=round(bn(1)*sampling/1000);
postsamps=round(bn(2)*sampling/1000);

d=dir;
dstr={d.name};
filelist={};
for ifile=1:length(dstr)
    if length(dstr{ifile})>4
        a= ~isempty(strfind(dstr{ifile},day));
        %b= strcmp(dstr{ifile}(end-2:end),'mat');
        b= isempty(strfind(dstr{ifile},'Long'));
        %if (~isempty(strfind(dstr{ifile},day))) & strcmp(dstr{ifile}(end-2:end),'mat') %This is weird, but matlab in 028 doesn't seem to like this statement, though it should work
        if a & b    %searches for day in file name, and it must be a mat file, i.e. end in mat
            if isfile([dstr{ifile} 'Long.mat'])     %Only keep those that have the Long File
                filelist{end+1}=dstr{ifile};
            end
        end
    end
end
nfile=length(filelist);


%Collect the Data before plotting it
maxvalue=0;
firstSpec=1;
useAlt=zeros(nevts,nfile);
for ifile=1:nfile
    disp(['loading ' filelist{ifile}])
    load(filelist{ifile},'-mat')
    load([filelist{ifile} 'Long.mat'])
    
    fileDepth(ifile)=Depth;
    fileBrain(ifile,:)=Brain<=Depth;
    
%     Lloaded=0;
%     trllength=diff(TrialStart_(:,1));
%     trllength(end+1)=length(nonzeros(EyeX_(end,1)))*1000/sampling; %converts from samples to ms
    for iev=1:nevts
        disp(['looking for ' EvList{iev}])
        
        VarList=EvList{iev};
        isvar
        if ~VarAns
            disp(['Could not find Event: ' VarList ' in file: ' filelist{ifile}])
            if ~isempty(AltEvList{iev})
                VarList=AltEvList{iev};
                isvar
                if VarAns
                    disp(['Found Alternate Event: ' VarList ' in file: ' filelist{ifile} ' . Will use that for analysis.'])
                    useAlt(iev,ifile)=1;
                else
                    disp(['Could not find Alternate Event: ' VarList ' in file: ' filelist{ifile} ' . Moving on to next event.'])
                end
            else
                disp(['No Alternate Event listed. Moving on to next event.'])
            end
        end
        
        if VarAns   %Will be one if either primary or alternate event are found in the file
            if useAlt(iev,ifile)
                eval(['RefEv=' AltEvList{iev} '(:,1);'])
            else
                eval(['RefEv=' EvList{iev} '(:,1);'])
            end
%             if RefEv(1)<TrialStart_(1)
%                 disp(['Found a ' EvList{iev} ' before the first TrialStart_, losing a trial'])
%                 RefEv=RefEv(2:end);
%             end
            keepers=find(RefEv>0);  %need to weed out the NaNs
            %length(RefEv)
            %length(keepers)
            %length(TrialStart_)
            RefEv=RefEv(keepers)+TrialStart_(keepers);  %for using Long analog signals, puts everything in reference to time of the beginning of the experiment
            RefEv=round(RefEv*sampling/1000)+1; %Finds the nearest sample to RefEv given the sampling rate (rounds up if half-way between samples)
            for ich=1:nch
                tRefEv=RefEv;
                tch=chanlist(ich);
                if tch<10
                    varstr=['AD0' num2str(tch) 'Long'];
                else
                    varstr=['AD' num2str(tch) 'Long'];
                end
                VarList=varstr;
                isvar
                if ~VarAns
                    disp(['Could not find: ' varstr ' in file: ' filelist{ifile} ' . Skipping that and moving on to next variable.'])
                else
                    eval(['LFP=' varstr ';']);
                    endsamp=length(LFP);
                    %check inputs to be sure not be out of range
                    if presamps+tRefEv(1)<1
                        tRefEv=tRefEv(2:end);
                        disp(['Lost first trial because the data was cut off.'])
                    end
                    if postsamps+tRefEv(end)>endsamp
                        tRefEv=tRefEv(1:end-1);
                        disp(['Lost last trial because the data was cut off.']) 
                    end
                    sLFP=zeros(length(tRefEv),postsamps-presamps+1);
                    %postsamps-presamps+1
                    %length(tRefEv)
                    %length(RefEv)
                    for itr=1:length(tRefEv)
                        sLFP(itr,:)=LFP(presamps+tRefEv(itr):postsamps+tRefEv(itr));
                    end                  
% reshape(a([b-2 b-1])',length(b),2) for addressing a long vector a (like 
% an analog signal) in one line, around a vector of timestamps b (like the event timestamp), and
% putting it in a 2D array; would require a string the length of [b-2 b-1
% ...], one for each sample....
                    
%check beginning of window This was if we were using the array of LFPs, but it doesn't look like we are
%                    TrTest(:,1)=RefEv+bn(1)>0;
%                    TrTest(:,2)=RefEv+bn(2)<trllength;
%                    if all(all(TrTest))
                                                                           
%function [spec,f,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
                    if firstSpec
                        [Spec{iev,ifile,ich},f,N,dN,nwin]=LFPSpec(sLFP,tapers,sampling,dn,fk,0);
                        firstSpec=0;
                        size(Spec{iev,ifile,ich})
                    else
                        Spec{iev,ifile,ich}=LFPSpec(sLFP,tapers,sampling,dn,fk,0);
                        size(Spec{iev,ifile,ich})
                    end
                    if max(max(Spec{iev,ifile,ich}))>maxvalue
                        maxvalue=max(max(Spec{iev,ifile,ich}));
                    end

                end %if we found var
            end %for ich
        end %if we found RefEvent
        
        if useAlt(iev,ifile)    %need to clear event variables in case they don't exist in the next file
            clear(AltEvList{iev})
        else
            clear(EvList{iev})
        end
        
    end %for iev
end %for ifile


%set up figure
if nch==3
    ncol=1;
else
    ncol=1;
end
nrow=4;

%this assumes per event the same number of axes
%nax=nch*nfile; %per Event type
% axperfig=ncol*nrow*nch
% exFigs=floor(nax/axperfig); %per Event type
% resax=nax-axperfig*exFigs;

%plot settings that shouldn't change with each plot
numYTicks=5;
numXTicks=4;
freqind=round(linspace(1,length(f),numYTicks));
freqvals=round(f(freqind));
freqind(1)=.5;

%t0=0; %ms time for first data sample; which is not actually included in x-axis plot
Nms=N*1000/sampling; %convert back to ms
dnms=dN*1000/sampling; %convert back to ms
tind=round(linspace(1,nwin,numXTicks));
tvals=(tind-1)*dnms+bn(1)+Nms/2;
tind(1)=.5;

% tvals
% tind
% freqvals
% freqind
% size(Spec{1,1,1})

fiperfig=ncol*nrow;
for iev=1:nevts
    %Change event names for matlab plotting
    if any(strfind(EvList{iev},'_'))
        inds=strfind(EvList{iev},'_');
        EvList{iev}(inds)=' ';
    end
    if any(strfind(AltEvList{iev},'_'))
        inds=strfind(AltEvList{iev},'_');
        AltEvList{iev}(inds)=' ';
    end
    
    tstr=(['Log10 multitaper Spectrum from ' EvList{iev} ' with ' num2str(Nms) ' ms win; tstep ' num2str(dnms) ' ms']);
  
    iFig=1;         %per Event type
    Fig(iev,iFig).FigHandle = figure('Position', [50 70 1400 800]);
    
    c=1;
    r=0;
    nplotbase=-ncol*nch;
    for ifile=1:nfile
        %drawnow
        %pause(3)
        if ifile>fiperfig*iFig
            Fig(iev,iFig).MainAx=axes('Position',[0,0,1,1],'Ytick',[],'XTick',[]);
            hold on
            set(Fig(iev,iFig).MainAx,'Visible','off');
            Fig(iev,iFig).TitHan=text(.5,.96,tstr);
            set(Fig(iev,iFig).TitHan,'HorizontalAlignment','center','Units','normalized','FontWeight','bold', ...
                'Position',[.5,.96,0]);
            iFig=iFig+1;         %per Event type
            Fig(iev,iFig).FigHandle = figure('Position', [50 70 1400 800]);
            
            c=1;
            r=0;
            nplotbase=-ncol*nch;
        end
        nplotbase=nplotbase+ncol*nch;

        r=r+1;
        if r>nrow   %should only happen if ncol>1
            %disp('should be changing columns')
            r=r-nrow;
            c=c+1;
            nplotbase=nch*(c-1);
        end
        for ich=1:nch
            if ~isempty(Spec{iev,ifile,ich})
                Fig(iev,iFig).AxHandle(ifile-fiperfig*(iFig-1),ich)=subplot(nrow,ncol*nch,ich+nplotbase);
                imagesc(log10(Spec{iev,ifile,ich}'),[0 log10(maxvalue)]) %add 1e-8 to avoid plotting log of zero, it happens with fake data sometimes
                axis xy
                axhand=gca;
                
                set(axhand,'XTickLabel',tvals);
                set(axhand,'XTick',tind);
                set(axhand,'YTickLabel',freqvals);
                set(axhand,'YTick',freqind);
                
                if ich==nch & (ifile==nfile |r==nrow)
                    colorbar('vert');
                end

                if fileBrain(ifile,ich)
                    Brstr=' Br';
                else
                    Brstr='';
                end
                if useAlt(iev,ifile)
                    Brstr=[Brstr ' ' AltEvList{iev}];
                end
                if ich==1
                    ylabel('Hz')
                    if r==1
                        title([num2str(Imp.Rep(ich)) ' kOhm ' num2str(fileDepth(ifile)) ' um' Brstr])
                    else
                        title([num2str(fileDepth(ifile)) ' um' Brstr])
                    end
                else
                    if r==1
                        title([num2str(Imp.Rep(ich)) ' kOhm ' num2str(fileDepth(ifile)) ' um' Brstr])
                    else
                        title([num2str(fileDepth(ifile)) ' um' Brstr])
                    end
                end                         
                if r==nrow|ifile==nfile
                    xlabel('win cent (ms)')
                end
                
            end
            
        end
    end
    Fig(iev,iFig).MainAx=axes('Position',[0,0,1,1],'Ytick',[],'XTick',[]);
    hold on
    set(Fig(iev,iFig).MainAx,'Visible','off');
    Fig(iev,iFig).TitHan=text(.5,.96,tstr);
    set(Fig(iev,iFig).TitHan,'HorizontalAlignment','center','Units','normalized','FontWeight','bold', ...
        'Position',[.5,.96,0])
end



