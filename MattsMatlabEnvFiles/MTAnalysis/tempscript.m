%tempscript.m
% allsigs(1,:)=AD01;
% allsigs(2,:)=AD17;
% allsigs(3,:)=AD18;

Fs=20000;
sigf=50;

testlinphfit=0;
testnlfit=0;
ovtest=0;
offsettest=0;
cosdiffofftest=0;
cosdiffontest=0;    %Note- we can't do the cosdiffontest unless we don't use the MT filtered data at all... for now let's just keep it the way it is
shapeanal=1;

clear tmpph
winlen=50; %samples

if testlinphfit
    if ~offsettest
        for isig=(1:3)
            sttime=335;    %ms
            endtime=360;   %ms
            stsamp=sttime*Fs/1000;
            endsamp=endtime*Fs/1000;
            clear tmpph
            tmpph(isig,:)=(angle(Hilb(isig,stsamp:endsamp+winlen-1)));%*180/pi;  %degrees
            tmpt=sttime:1/Fs*1000:(endsamp+winlen-1)/Fs*1000;    %need to account for winlen here, but not below
            %tmpinstf(isig,:)=diff(ph)/freqconv;
            figure
            subplot(311)
            plot(tmpt,tmpph(isig,:)*180/pi)
            tmpph(isig,:)=unwrap(tmpph(isig,:));
            title(['Hilb Phase (degrees) for sig: ' num2str(isig)])
            xlabel('time(ms)')
            subplot(312)
            clear tmpinstf mse
            for is=1:endsamp-stsamp+1
                tmpp=polyfit([1:winlen],tmpph(isig,is:is+winlen-1),1);
                mse(isig,is)=mean((tmpph(isig,is:is+winlen-1)-[1:winlen]*tmpp(1)+tmpp(2)).^2);
                tmpinstf(isig,is)=tmpp(1)/freqconv;
            end
            tmpt=sttime:1/Fs*1000:endtime;
            plot(tmpt,tmpinstf(isig,:))
            title(['InstFreq from poly fit for sig: ' num2str(isig)])
            xlabel('time(ms)')
            subplot(313)
            plot(tmpt,mse(isig,:))
            title(['MSE from poly fit for sig: ' num2str(isig)])
            xlabel('time(ms)')
        end
    else
        for isig=(1:3)
            sttime=5340;    %ms
            endtime=5360;   %ms
            stsamp=sttime*Fs/1000;
            endsamp=endtime*Fs/1000;
            clear tmpph
            tmpph(isig,:)=(angle(Hilb(isig,stsamp:endsamp+winlen-1)));%*180/pi;  %degrees
            tmpt=sttime:1/Fs*1000:(endsamp+winlen-1)/Fs*1000;    %need to account for winlen here, but not below
            %tmpinstf(isig,:)=diff(ph)/freqconv;
            figure
            subplot(311)
            plot(tmpt,tmpph(isig,:)*180/pi)
            tmpph(isig,:)=unwrap(tmpph(isig,:));
            title(['Hilb Phase (degrees) for sig: ' num2str(isig)])
            xlabel('time(ms)')
            subplot(312)
            clear tmpinstf mse
            for is=1:endsamp-stsamp+1
                tmpp=polyfit([1:winlen],tmpph(isig,is:is+winlen-1),1);
                mse(isig,is)=mean((tmpph(isig,is:is+winlen-1)-[1:winlen]*tmpp(1)+tmpp(2)).^2);
                tmpinstf(isig,is)=tmpp(1)/freqconv;
            end
            tmpt=sttime:1/Fs*1000:endtime;
            plot(tmpt,tmpinstf(isig,:))
            title(['InstFreq from poly fit for sig: ' num2str(isig)])
            xlabel('time(ms)')
            subplot(313)
            plot(tmpt,mse(isig,:))
            title(['MSE from poly fit for sig: ' num2str(isig)])
            xlabel('time(ms)')
        end
    end
end


if testnlfit
    if ~offsettest
        nfitcycs=12;
        sigf=50; %Hz
        initt=348; %ms
        initsamp=initt*Fs/1000;
        ltslack=40; %ms
        normhilb=1
        for isig=(1:3)
            stfitsamp=(initt-ltslack)*Fs/1000;
            endfitsamp=initsamp+nfitcycs*1/50*Fs;   %1/50 because this was designed for 50 Hz
            cursig=allsigs(isig,stfitsamp:endfitsamp);
            tmpsig=(cursig);%./abs(Hilb(isig,stfitsamp:endfitsamp));    %normalize by Hilbert mag so we don't have to fit a sine wave fxn w/ varying amplitude
            if normhilb tmpsig=tmpsig./abs(Hilb(isig,stfitsamp:endfitsamp));    end
            initPh=0;
            fitsamps=(stfitsamp:endfitsamp);
            plott=fitsamps*1000/Fs;
            %         yhat=fitsined11([initPh,initsamp],fitsamps);
            %         figure
            %         plot(yhat)
            [newparams,r1]=nlinfit(fitsamps,tmpsig,@fitsined11,[initPh,initsamp],options); %the inputs to nlinfit seem to both have to be row vectors
            figure
            hold on
            plot(plott,tmpsig,'b');
            %plot(cursig,'g');
            reconsig=1*cos(angle(Hilb(isig,stfitsamp:endfitsamp)));
            %plot(reconsig,'m');
            w=sigf*2*pi/20000;    %convert to rad/samp with Fs=20000
            yhat=fitsined11(newparams,fitsamps);
            projleftsamps=0;
            yhat=1*sin(w*(fitsamps-newparams(2))+newparams(1)).*(fitsamps>=newparams(2)-projleftsamps);
            plot(plott,yhat,'r')
            title(['nlinfit result for sig: ' num2str(isig)])
            xlabel('time(ms)')
        end
    else
        nfitcycs=12;
        sigf=50; %Hz
        endt=5351.4; %ms
        endsamp=endt*Fs/1000;
        rtslack=12; %ms
        normhilb=1;
        for isig=(1:3)
            endfitsamp=(endt+ltslack)*Fs/1000;
            stfitsamp=endsamp-nfitcycs*1/sigf*Fs;   %1/50 because this was designed for 50 Hz
            cursig=allsigs(isig,stfitsamp:endfitsamp);
            tmpsig=(cursig);%./abs(Hilb(isig,stfitsamp:endfitsamp));    %normalize by Hilbert mag so we don't have to fit a sine wave fxn w/ varying amplitude
            if normhilb tmpsig=tmpsig./abs(Hilb(isig,stfitsamp:endfitsamp));    end
            endPh=0;
            fitsamps=(stfitsamp:endfitsamp);
            plott=fitsamps*1000/Fs;
            %         yhat=fitsined11([initPh,initsamp],fitsamps);
            %         figure
            %         plot(yhat)
            [newparams,r1]=nlinfit(fitsamps,tmpsig,@fitsineoff11,[endPh,endsamp],options); %the inputs to nlinfit seem to both have to be row vectors
            figure
            hold on
            plot(plott,tmpsig,'b');
            %plot(cursig,'g');
            reconsig=1*cos(angle(Hilb(isig,stfitsamp:endfitsamp)));
            %plot(reconsig,'m');
            w=sigf*2*pi/20000;    %convert to rad/samp with Fs=20000
            yhat=fitsined11(newparams,fitsamps);
            projrightsamps=0;
            yhat=1*sin(w*(fitsamps-newparams(2))+newparams(1)).*(fitsamps<=newparams(2)+projrightsamps);
            plot(plott,yhat,'r')
            title(['nlinfit result for sig: ' num2str(isig)])
            xlabel('time(ms)')
        end
    end
end

if ovtest  %for sig at least we can use maybe half of a cycle use time win for OvTurnOn...
    usebasemax=0;   %use std of baselin if set to zero
    nrels=[3 3 2]';
    baseend=338; %time in ms
    
    basedur=6.3; %sec; 1 sec seems like a better number
    maxondur=.0024;
    maxoncyc=70; %degrees
    ondur=min(maxondur,maxoncyc/(360*sigf));    %sec- this is the duration that a signal needs to be on or off to register
    pctoncutoff=.99;    %There has to be percentage of on samples over ondur to register an on or an off

    nonsamps=round(ondur*Fs);
    nonsampsg=ceil(nonsamps*pctoncutoff);
    if usebasemax   cutoffval=nrels.*max(allsigs(:,1:basedur*adfreq),[],2);
    else    cutoffval=nrels.*std(allsigs(:,1:basedur*adfreq),[],2);  end
    for isig=(1:3)
        ontimes=find(abs(allsigs(isig,basedur*adfreq:end))>cutoffval(isig))+basedur*adfreq-1;
        is=1;   %need to make sure on dur is met
        found=0;
        while is+nonsampsg-1<length(ontimes) && ~found
            if ontimes(is+nonsampsg-1)-ontimes(is)<=nonsamps-1   %This is the amount of total samples that could have been obtained between the times from the first and last sample covering the total amount of onsamples needed to registered over on dur in order to consider the onset to have been found
                found=1;
            else is=is+1;   end
        end
        if found    tmpOvOnTime(isig)=ontimes(is);
        else    tmpOvOnTime(isig)=0;   end
    end
    tmpOvOnTime=tmpOvOnTime/Fs*1000;     %in ms
    disp(['tmpOvOnTime: ' num2str(tmpOvOnTime)])
    
    tmpOvOnTime2=findonset(allsigs(:,basedur*adfreq:end),allsigs(:,1:basedur*adfreq),nonsamps,pctoncutoff,nrels,usebasemax);
    tmpOvOnTime2=(tmpOvOnTime2+basedur*adfreq-1)/Fs*1000;     %in ms
    disp(['tmpOvOnTime2: ' num2str(tmpOvOnTime2')])
end

if cosdiffofftest
    fixedMTdur=2; %sec  This is just known because we created the sound files to be that way
    nslackcycs=2;   %assumes numextcycs is 15 and minexttime=.1 in the file that created the MT signal
    minexttime=.1;
    nfitcycs=12;
    chkcycs=5;
    
    viewbaseref=0;
    viewchkref=0;
    for isig=(1:3)
        fitdur=nfitcycs*1/sigf; %sec
        stfitsamp=(tmpOvOnTime(isig)/1000+fixedMTdur)*Fs;
        endfitsamp=stfitsamp+nfitcycs*1/sigf*Fs;
        tmpbase=allsigs(isig,stfitsamp:endfitsamp);
        tb=0:1/Fs:fitdur;
        tmpHilb=hilbert(tmpbase);
        tmpamp=mean(abs(tmpHilb));
        
        chkdur=chkcycs*1/sigf;
        if fitdur+chkdur<minexttime chkdur=minexttime-fitdur+chkdur;    end
        tchk=0:1/Fs:chkdur; %in units of secs here
        endchksamp=endfitsamp+chkdur*Fs;
        tmpchk=allsigs(isig,endfitsamp:endchksamp);
        
        
        %try nlinfit first, then try Hilbert phase + amp fit only if that
        %doesn't work - ALLOW THE INPUT FREQ TO CHANGE
        [newparams,r]=nlinfit(tb,tmpbase,@fitsine,[tmpamp,sigf*2*pi,angle(tmpHilb(1))+pi/2,mean(tmpbase)],options);   %sigf itself can work since the samples (tb) are in units of seconds
        ResidRatio=rms(r)/rms(tmpbase);                        %Note: we add the pi/2 because the angle deals with the cosine phase, but what we want os the sin phase, since that's what the function fits to the data
        tmpsinefit= ResidRatio<=ResidFrac;
        
        if tmpsinefit
            disp(['nlinfit worked for sig: ' num2str(isig)])
            newparams=CleanParams(newparams,freqconv);
            newparams(2)=newparams(2)*freqconv/(2*pi);     %params= [Amp,Freq,Phase,Mean]
            baseref=newparams(1)*sin(2*pi*tb*newparams(2)+newparams(3))+newparams(4);   %fxn outputs the appropriate phase for a sin wave
            chkref=newparams(1)*sin(2*pi*(tchk+fitdur)*newparams(2)+newparams(3))+newparams(4);
            finf(isig)=newparams(2);
        else
            disp(['nlinfit didn''t work for sig: ' num2str(isig) ', using Hilbert estimator'])
            tmpp=polyfit(tb,unwrap(angle(tmpHilb)),1);
            endph=tmpp(1)*(endfitsamp-stfitsamp+1)+tmpp(2); %Note- this will be ph for a cosine
            while endph>=2*pi    endph=endph-2*pi;  end
            while endph<0    endph=endph+2*pi;  end
            while tmpp(2)>=2*pi    tmpp(2)=tmpp(2)-2*pi;  end
            while tmpp(2)<0    tmpp(2)=tmpp(2)+2*pi;  end
            finf=tmpp(1)/(2*pi);
            baseref=tmpamp*cos(2*pi*tb*finf+tmpp(2));
            chkref=tmpamp*cos(2*pi*tchk*finf+endph);
        end                    
        
        msebase=(tmpbase-baseref).^2;
        if viewbaseref
            figure
            hold on
            plot(tb*1000+stfitsamp*1000/Fs,baseref,'rx-')    %plots time in units of msecs
            plot(tb*1000+stfitsamp*1000/Fs,tmpbase,'bx-')
            title(['Baseline ref for cosofftest for sig ' num2str(isig) ]) 
            xlabel('time ms')
        end
                
        msechk=(tmpchk-chkref).^2;
        if viewchkref
            figure
            hold on
            plot(tchk*1000+endfitsamp*1000/Fs,chkref,'rx-') %plots time in units of msecs
            plot(tchk*1000+endfitsamp*1000/Fs,tmpchk,'bx-')
            title(['Check ref for cosofftest for sig ' num2str(isig) ]) 
            xlabel('time ms')
        end
        
        usebasemax=0;   %use std of baselin if set to zero
        nrels=[3 4 4]';
        
        maxondur=.002;
        maxoncyc=70; %degrees
        ondur=min(maxondur,maxoncyc/(360*sigf));    %sec- this is the duration that a signal needs to be on or off to register
        pctoncutoff=.95;    %There has to be percentage of on samples over ondur to register an on or an off

        nonsamps=round(ondur*Fs);
        nonsampsg=ceil(nonsamps*pctoncutoff);
        if usebasemax   cutoffval(isig)=nrels(isig).*max(msebase);
        else    cutoffval(isig)=nrels(isig).*std(msebase);  end

        ontimes=find(msechk<cutoffval(isig))+endfitsamp;
        is=length(ontimes);   %need to make sure on dur is met
        found=0;
        while is-(nonsampsg-1)>0 && ~found
            if ontimes(is) - ontimes(is-(nonsampsg-1)) <nonsamps-1   found=1;
            else is=is-1;   end
        end
        if found    tmpOffTime(isig)=ontimes(is);
        else    tmpOffTime(isig)=0;   end
        
        tmpOffTime2(isig)=findoffset(msechk,msebase,nonsamps,pctoncutoff,nrels(isig),usebasemax,1);
        tmpOffTime2(isig)
        if tmpOffTime2>0    tmpOffTime2(isig)=tmpOffTime2(isig)+endfitsamp; end
        
    end
    tmpOffTime=tmpOffTime/Fs*1000;     %in ms
    disp(['tmpOffTime: ' num2str(tmpOffTime)])
    
    tmpOffTime2=tmpOffTime2/Fs*1000;     %in ms
    disp(['tmpOffTime2: ' num2str(tmpOffTime2)]) 
end


if shapeanal
    time=(1:length(allsigs))/Fs*1000;
    figure
    hold on
    plot(time,allsigs(1,:),'b-x')
    plot(time,allsigs(2,:),'r-x')
    plot(time,allsigs(3,:),'g-x')
    xlabel('time (ms)')
    title(['Shape plot for : ' recname])
end
