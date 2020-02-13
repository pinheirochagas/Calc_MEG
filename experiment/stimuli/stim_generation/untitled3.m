    SubFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:);
    SubFinaldM1 = AddSubFinaldM1(AddSubFinaldM1(:,2)==10,:);
    SubFinaldM2 = AddSubFinaldM2(AddSubFinaldM2(:,2)==10,:);
    SubFinaldM3 = AddSubFinaldM3(AddSubFinaldM3(:,2)==10,:);
    SubFinaldM4 = AddSubFinaldP4(AddSubFinaldP4(:,2)==10,:);
    SubFinaldP1 = AddSubFinaldP1(AddSubFinaldP1(:,2)==10,:);
    SubFinaldP2 = AddSubFinaldP2(AddSubFinaldP2(:,2)==10,:);
    SubFinaldP3 = AddSubFinaldP3(AddSubFinaldP3(:,2)==10,:);
    SubFinaldP4 = AddSubFinaldP4(AddSubFinaldP4(:,2)==10,:);
    
    AddstdF(rep) = std([length(SubFinaldM1),length(SubFinaldM2),...
    length(SubFinaldM3),length(SubFinaldM4),length(SubFinaldP1),...
    length(SubFinaldP2),length(SubFinaldP3),length(SubFinaldP4)]);