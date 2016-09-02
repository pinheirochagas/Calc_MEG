function [StatsOut,PreTests]=MyScatterPlot(cVar1,cVar2,S,color,AddRegLine,AddConfEll,M,MLW,RegLineLW,RegLineColor, Lab1,Lab2)
% 
%
% Inputs are cVar1 (x-ax var) and cVar2 (y-ax var). This will produce a
% scatterplot in the current axis, and optionally add the line of best fit
% and add a confidenc ellipse.
%
% Note that the outputs of a linear regression would also be available in
% cB,cBint,cR,cRint,cStats (if a line of best fit is added)
%
% You CAN input multiple indpendent factors by having cVar1 have multiple
% columns. The regressions will be performed on all the facors, but only
% plotted using teh first column.
%
% Setting AddRegLine to 2 will only add the reg line in the case where the regression is significant (the default behavior)   

if nargin<12 || isempty(Lab2)      Lab2='Y';     end
if nargin<11 || isempty(Lab1)      Lab1='X';     end
if nargin<10 || isempty(RegLineColor)      RegLineColor=[0 0 0];     end
if nargin<9 || isempty(RegLineLW)      RegLineLW=1;     end
if nargin<8 || isempty(MLW)      MLW=1;     end
if nargin<7 || isempty(M)      M='o';     end
if nargin<6 || isempty(AddConfEll)    AddConfEll=0;    end
if nargin<5 || isempty(AddRegLine)    AddRegLine=2;    end
if nargin<4 || isempty(color)    color=[0 0 0];    end
if nargin<3 || isempty(S)    S=10;    end

%put data in column vectors
[r,c]=size(cVar1);
if c>r      cVar1=cVar1';   end
[r,c]=size(cVar2);
if c>r      cVar2=cVar2';   end

% remove NaN entries
GoodInds= ~( isnan(cVar2) | isnan(cVar1(:,1)) );  
cVar1=cVar1(GoodInds);
cVar2=cVar2(GoodInds);
if length(S)>1;        S=S(GoodInds);      end
if size(color,1)>1;    color=color(GoodInds,:);      end
if length(M)>1;        M=M(GoodInds);      end    

n=sum( GoodInds );
    


hold on
if AddConfEll
    cCov=cov(cVar1,cVar2);
    h=error_ellipse(cCov,[nanmean(cVar1(:,1)) nanmean(cVar2)] ,'conf',.95);   %I got this from the matlab file exchange. Very cool function    
    set(h,'Color',color)
end


[StatsOut.Spear_rho, StatsOut.Spear_p]=corr( cVar2,cVar1,'type','Spearman' );
StatsOut.Spear_df= n-2;
disp([Lab2 ' vs ' Lab1 ': SpearRho(' num2str(StatsOut.Spear_df) ') = ' myRoundForDisp3(StatsOut.Spear_rho,-2) ';  p= ' myRoundForDisp3(StatsOut.Spear_p,-3) ])

if nargout>0 || AddRegLine
    tf=gcf;
    [b, bint,PreTests,~,~,stats]= my_regress(cVar2,[repmat(1,length(cVar1),1) cVar1]);
        
    %arrange statsout
    StatsOut.Intercept=b(1);
    StatsOut.InterceptConfInt=bint(1,:);
    StatsOut.Slope=b(2);
    StatsOut.SlopeConfInt=bint(2,:);
    StatsOut.r=stats(1);
    StatsOut.p=stats(3);          
    
    disp(['Linear fit: ' Lab2 ' = ' myRoundForDisp3(StatsOut.Slope,-2) ' * ' Lab1 ' + ' myRoundForDisp3(StatsOut.Intercept,-2)])
    disp(['Slope = ' myRoundForDisp3(StatsOut.Slope,-2) ' +/- ' myRoundForDisp3(StatsOut.SlopeConfInt(2)-StatsOut.SlopeConfInt(1),-2) ';  p= ' myRoundForDisp3(StatsOut.p,-3) ';  r2=' myRoundForDisp3(stats(1),-2)  ])
    
    figure(tf);     %makes initial figure current in case my_regress finds no-normality and plots the distribution
    if AddRegLine==1 || (AddRegLine==2 && StatsOut.p<0.05) 
        minV1=min(cVar1(:,1));
        maxV1=max(cVar1(:,1));
        plot([minV1 maxV1],[b(1)+b(2)*minV1  b(1)+b(2)*maxV1],'Color', RegLineColor,'LineWidth',RegLineLW)
    end
else
    StatsOut.Intercept=NaN;
    StatsOut.InterceptConfInt=NaN(1,3);
    StatsOut.Slope=NaN;
    StatsOut.SlopeConfInt=NaN(1,3);
    StatsOut.p=NaN;
end


% process M, we can shorten it if it's length is > 1, but all values are the same   
if length(M)>1 && length(unique(M))==1
    if iscell(M)
        M=M{1};
    else
        M=M(1);
    end
end
        

% plot scatter data
% if at this point length(M) > 1, we need a for loop for unique values of M. Else we can just plot with one line       
if length(M)>1
    % need to elongate S and color if necessary   
    n=length(M);
    if length(S)==1
        S=repmat(S,n,1);
    end
    if size(color,1)==1
        color=repmat(color,n,1);
    end
    
    [uMs, ~, uMinds]=unique(M);
    for im=1:length(uMs)
        curInds=find(uMinds==im);
        if strcmp(uMs{im},'o')
            tmpMLW=1;
        else
            tmpMLW=MLW;
        end
        th=scatter(cVar1(curInds,1),cVar2(curInds,1),S(curInds,1),color(curInds,:),uMs{im},'LineWidth',tmpMLW,'MarkerFaceColor',color(curInds(1),:));
        %get(th);
    end
else
    scatter(cVar1(:,1),cVar2,S,color,M)
end
    
AxisAlmostTight

                      