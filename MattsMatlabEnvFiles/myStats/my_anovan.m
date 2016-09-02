function [p,PreTests,t,stats,terms] = my_anovan(y,group,varargin)
% function [p,PreTests,t,stats,terms] = my_anovan(y,group,varargin)
%
% Written by MJN on 080409
%
% the t above stands for table... i.e. the anova table
%
% The intention of this file is to perform the tests as I'd like to do them
% to be sure that the anova assumptions aren't violated too badly on a 
% dataset before running an anova. If any of the assumptions are violated
% the program will plot a histogram of all the cells, while displaying the
% values of all the various statistics in appropriate places. The anovan is
% still ultimately in all cases, even if the assumptions are considered 
% violated based on the parameters set within this file
%
% Note- presently the parameters for the assumption Pass/Fail cutoffs are 
% hard-coded into this program. If that becomes a problem and it's desired 
% to make these an input to this functino, I can add that later, probably 
% by making an options structure the third input before varargin. (see 
% CorrectData from the impedance study supplementary code)
%
% Also note, this doesn't deal with the independence assumption. All RTs
% (and I'd be willing to bet trial by trial neural data too) show
% correlations between trials, but provided that the parameters being
% investigated is randomly assorted across trials it shouldn't matter (see
% the non-stationary ms for more details.)
%
% Inputs are the same as anovan(y, group, varargin)
%
% Outputs are the same as anovan except that the second output is a
% structure PreTests that has the following fields:
%   PreTests.n          -cell array of Samp Sizes per cell (i.e. cell of the ANOVA)
%   PreTests.Var        -cell array of Variances per cell
%   PreTests.Skew       -cell array of Skew statistic per cell
%   PreTests.Kurt       -cell array of Kurtosis statistic per cell
%   PreTests.MaxVarRat  -scalar ratio of largest cell variance to smalles cell variance 
%   PreTests.MaxNRat    -scalar ratio of largest cell num of samps to smallest cell num of samps
%   PreTests.FailTest
%
%   Note- this won't work for continuous inputs

%%%%% Set the parameter cutoffs
% ratio of largest to smallest variance > 4
% unequal cell sizes- ratio of largest to smallest cell >2
% skewness above 1 (or below -1... i.e. test abs value of skew
% kurtosis below 1.5 or above 5 (kurtosis of a normal dist is 3... see note below for kurtosis and matlab
CU.VarRat=4;
CU.SizeRat=2;
CU.Skew=1;
CU.Kurt=[1.5 5];

cf=gcf;

%initialize
FailTest=0;
%need to det number of cells, and calc each output item per cell, and record max and min for cell size and variance
nd=length(group);   %this assumes that group is a cell array
ngroups=repmat(0,nd,1);
curgroups=ngroups;
for id=1:nd 
    glabs{id}=unique(group{id});
    ngroups(id)=length(unique(group{id}));
end

[y2,allgrps] = removenans(y,group); %this subfunction is borrowed from matlab's anovan, slightly adjusted

[PreTests FailTest VarLims NLims]=RecFor(1,nd,curgroups,ngroups,y2,allgrps,[],CU,FailTest,[],[]);
PreTests.MaxVarRat=VarLims(2)/VarLims(1);
PreTests.MaxNRat=NLims(2)/NLims(1);

if ~FailTest && ( PreTests.MaxVarRat>CU.VarRat || PreTests.MaxNRat>CU.SizeRat )
    FailTest=1;
end

%plot the hists if we failed any tests
if FailTest
    disp('Data failed anovan asssumption tests.')
    disp(['MaxVarRat: ' num2str(PreTests.MaxVarRat) ' MaxNRat: ' num2str(PreTests.MaxNRat)])
    disp(['Skew: ' num2str(PreTests.Skew)])
    disp(['Kurt: ' num2str(PreTests.Kurt)])
    
    RecFor(1,nd,curgroups,ngroups,y2,allgrps,PreTests);
end

%[p,t,stats,terms] = anovan(y,group,varargin);
%w/ varargin as a cell, the above line won't work, so we have to go through the pain in the ass for loop below  
anstr='[p,t,stats,terms] = anovan(y,group,';
for iv=1:length(varargin)
    anstr=[anstr '''' varargin{iv} ''','];
end
anstr(end:end+1)=');';
eval(anstr)

PreTests.FailTest=FailTest;

figure(cf);


%--------------------
function [PreTests FailTest VarLims NLims]=RecFor(id,nd,curgroups,ngroups,y,allgrps,PreTests,CU,FailTest,VarLims,NLims)
%a recursive for loop called above to calculate stats for an un-known dimensional input
%
%I think there's a better way to do this with global variables so we don't
%have to copy the inputs so many times, but I'm having trouble with it

%note: nargin is 11 for normal calc loop... if nargin is less than that, it will be a plot loop
if nargin<11    
    plotflag=1;
    if id==1    h=[];    else   h=CU;   end     %b/c we pass h in as the 8th argument where CU normally would be        
else        plotflag=0;     end

if plotflag && (nd<=2 && id==1)       figure;     end

for ig=1:ngroups(id)
    curgroups(id)=ig;
    %start a figure for each iteration if we are exactly 2 dimensions above the last dimension
    if plotflag && id==nd-2     figure;     end
    if id<nd
        if plotflag     [h]=RecFor(id+1,nd,curgroups,ngroups,y,allgrps,PreTests,h);
        else    [PreTests FailTest VarLims NLims]=RecFor(id+1,nd,curgroups,ngroups,y,allgrps,PreTests,CU,FailTest,VarLims,NLims);   end
    else
        %calculate values- set up indicies
        Inds=repmat(1,length(y),1);
        estr=[];
        for iid=1:nd
            Inds=Inds & allgrps(:,iid)==curgroups(iid);
            estr=[estr num2str(curgroups(iid)) ','];
        end
        estr=estr(1:end-1);

        if ~plotflag
            %calculate values
            curs=skewness(y(Inds),0);    %The second input of 0 makes the matlab function correct for bias b/c the data is drwan from a population
            curk=kurtosis(y(Inds),0);    %ditto ... note that for matlab output of kurtosis of a normal distribution is 3 (it can't be negative by definition... like variance and all even moments)
            %Just FYI, for most stats references that I've seen, kurtosis is referred to on a scale after subtracting 3 from the absolute kurtosis, s.t. the kurtosis of a normal distribution will be 0
            curn=sum(Inds);
            curv=var(y(Inds));

            if isempty(VarLims)      %It's assumed that if VarLims is empty, NLims will be too
                VarLims=[curv curv];
                NLims=[curn curn];
            else
                if curv<VarLims(1)      VarLims(1)=curv;    end
                if curv>VarLims(2)      VarLims(2)=curv;    end
                if curn<NLims(1)      NLims(1)=curn;    end
                if curn>NLims(2)      NLims(2)=curn;    end
            end

            if ~FailTest && ( abs(curs)>CU.Skew || ~isbetween(curk,CU.Kurt) )
                FailTest=1;
            end

            eval(['PreTests.n(' estr ')=curn;'])
            eval(['PreTests.Var(' estr ')=curv;'])
            eval(['PreTests.Skew(' estr ')=curs;'])
            eval(['PreTests.Kurt(' estr ')=curk;'])
        else
            if nd==1    h(1,ig)=subplot(1,ngroups(end),ig);
            else    h(curgroups(end-1),ig)=subplot(ngroups(end-1),ngroups(end),(curgroups(end-1)-1)*ngroups(end)+ig);       end
            myHist(y(Inds),[],[],[],1)
            eval(['curn=PreTests.n(' estr ');'])
            eval(['curv=PreTests.Var(' estr ');'])
            eval(['curs=PreTests.Skew(' estr ');'])
            eval(['curk=PreTests.Kurt(' estr ');'])
            title(['cell ' estr ' n: ' num2str(curn) ', var: ' num2str(curv) ', skew: ' num2str(curs) ', kurt: ' num2str(curk)])
            xlabel('y');
            ylabel('count')
            AxisAlmostTight(.02,1)
            if ig==ngroups(id) && (nd==1 || curgroups(end-1)==ngroups(end-1))      StandardizeAxes(h);     end
        end
    end
end
if plotflag     PreTests=h;     end         %This only concerns the output for whatever level called this

% -----------------------------------
function [y,allgrps] = removenans(y,group,continuous)

% Find NaNs among response and group arrays
n = length(y);
nanrow = isnan(y);
ng = length(group);
for j=1:ng
   gj = group{j};
   if (size(gj,1) == 1), gj = gj(:); end
   if (size(gj,1) ~= n)
      error('stats:anovan:InputSizeMismatch',...
            'Group variable %d must have %d elements.',j,n);
   end
   if (ischar(gj)), gj = cellstr(gj); end
   if ~isvector(gj)
       error('stats:anovan:BadGroup',...
             'Grouping variable must be a vector or a character array.');
   end

   group{j} = gj;
   if (isnumeric(gj))
      nanrow = (nanrow | isnan(gj));
   elseif isa(gj,'categorical')
      nanrow = (nanrow | isundefined(gj));
   else
      nanrow = (nanrow | strcmp(gj,''));
   end
end

% Remove rows with NaN anywhere
y(nanrow) = [];
n = length(y);
ng = length(group);
dfvar = zeros(ng,1);
allgrps = zeros(n, ng);
allnames = cell(ng,1);

% Get arrays describing the groups
for j=1:ng
   gj = group{j};
   gj(nanrow,:) = [];
   group{j} = gj;
   
   [gij,gnj] = grp2idx(gj);
   nlevels = size(gnj,1);
   dfvar(j) = nlevels - 1;
   allgrps(:,j) = gij;
   allnames{j} = gnj;
end
