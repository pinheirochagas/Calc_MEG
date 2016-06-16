function comp = wmp_decomposition_getCorr(par, dat, channel, type_artifact, getcorr)

% perform decomposition
comp = [];
cfg               = [];
cfg.method        = par.decomposition.method;
cfg.numcomponent  = par.decomposition.comp_num;
cfg.channel       = channel;
tmp=1;
tmp2=1;
comp = ft_componentanalysis(cfg, dat);
if getcorr
    comp.meanCorr=zeros(3,cfg.numcomponent);
    
    for tmp2=1:cfg.numcomponent
        for tmp=1:length(dat.trial) % trials
            x=corrcoef(comp.trial{tmp}(tmp2,:), dat.ECGEOG{tmp}(1,:));
            CorrEOG1(tmp)=x(1,2);
            meanCorrEOG1_comp=mean(CorrEOG1);
            
            y=corrcoef(comp.trial{tmp}(tmp2,:), dat.ECGEOG{tmp}(2,:));
            CorrEOG2(tmp)=y(1,2);
            meanCorrEOG2_comp=mean(CorrEOG2);
            
            z=corrcoef(comp.trial{tmp}(tmp2,:), dat.ECGEOG{tmp}(3,:));
            CorrECG(tmp)=z(1,2);
            meanCorrECG_comp=mean(CorrECG);
        end
        comp.meanCorr(1,tmp2)=meanCorrEOG1_comp;
        comp.meanCorr(2,tmp2)=meanCorrEOG2_comp;
        comp.meanCorr(3,tmp2)=meanCorrECG_comp;
    end
    %     for tmp2=1:cfg.numcomponent
    %         for tmp=1:length(dat.trial) % trials
    %             for nart = 1%:length(type_artifact)
    % %                 clear CorrArtifact
    %                 switch type_artifact{nart}
    %                     case 'EOGv'
    %                         CorrArtifact(tmp)=corr(comp.trial{tmp}(tmp2,:)', dat.ECGEOG{tmp}(1,:)');
    %                         comp.meanCorr(1,tmp2)=mean(CorrArtifact);
    %                     case 'EOGh'
    %                         CorrArtifact(tmp)=corr(comp.trial{tmp}(tmp2,:)', dat.ECGEOG{tmp}(2,:)');
    %                         comp.meanCorr(2,tmp2)=mean(CorrArtifact);
    %                     case 'ECG'
    %                         CorrArtifact(tmp)=corr(comp.trial{tmp}(tmp2,:)', dat.ECGEOG{tmp}(3,:)');
    %                         comp.meanCorr(3,tmp2)=mean(CorrArtifact);
    %                 end
    %             end
    %         end
    %     end
    
    % Plot the correlation between EOG1, EOG2, ECG and the components
    figure;
    bar(comp.meanCorr', 'group')
    %     title(type_artifact);
    legend('EOGv', 'EOGh', 'ECG');
    ylim([-1 1]);
end




