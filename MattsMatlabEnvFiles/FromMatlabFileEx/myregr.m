function [slope,intercept,xtmp,cir,cir2,STAT]=myregr(x,y,verbose)
%MYREGR: Perform a least-squares linear regression.
%This function computes a least-square linear regression suppling several
%output information.
%   MJN's note: The primary usefulness of this function is that it will 
%   return the confidence region of the regression
%       This was also adjusted to allow NaN's in the input
%
% Syntax: 	myregr(x,y)
%      
%     Inputs:
%           X - Array of the independent variable 
%           Y - Array of the dependent variable
%           verbose - Flag to display all information- MJN adjusting this:
%               set verbose to 1 to just display plot, set verbose to 2
%               display the plot and all the random text, and set verbose 
%               to 0  to not include any output. NOTE- setting verbose to 0
%               will also ask the user qeustions and provide teh user to
%               press any key a few times while the program runs
%     Outputs:
%           - Slope with standard error an 95% C.I.
%           - Intercept with standard error an 95% C.I.
%           MJN addedbelow
%           -xtmp: the xvector to go with the confidence regions in
%               subsequent output arguments
%           -cir: a nx2 array defining the 95% confidence region for the
%               regression line. 
%           -cir2: a nx2 array defining the 95% confidence region for a new
%               observation
%               NOTE- that in the two above cases, n is the number of
%               observations after removing any Nans...
%
%           BACK to the orig. author's comments:
%           - Pearson's Correlation coefficient with 95% C.I. and its
%             adjusted form (depending on the elements of X and Y arrays)
%           - Spearman's Correlation coefficient
%           - Regression Standard Error
%           - Total Variability
%           - Variability due to regression
%           - Residual Variability
%           - Student's t-Test on Slope (to check if slope=0)
%           - Student's t-Test on Intercept (to check if intercept=0)
%           - Power of the regression
%           - a plot with:
%                o Data points
%                o Least squares regression line
%                o Red dotted lines: 95% Confidence interval of regression
%                o Green dotted lines: 95% Confidence interval of new y 
%                                       evaluation using this regression.
%
%   [Slope]=myregr(...) returns a structure of slope containing value, standard
%   error, lower and upper bounds 95% C.I.
%
%   [Slope,Intercept]=myregr(...) returns a structure of slope and intercept 
%   containing value, standard error, lower and upper bounds 95% C.I.
%
% Example:
%       x = [1.0 2.3 3.1 4.8 5.6 6.3];
%       y = [2.6 2.8 3.1 4.7 4.1 5.3];
%
%   Calling on Matlab the function: 
%             myregr(x,y)
%
%   Answer is:
%
%                         Slope
% -----------------------------------------------------------
%      Value          S.E.                95% C.I.  
% -----------------------------------------------------------
%    0.50107        0.09667        0.23267        0.76947
% -----------------------------------------------------------
%  
%                       Intercept
% -----------------------------------------------------------
%      Value          S.E.                95% C.I.  
% -----------------------------------------------------------
%    1.83755        0.41390        0.68838        2.98673
% -----------------------------------------------------------
%  
%             Pearson's Correlation Coefficient
% -----------------------------------------------------------
%      Value               95% C.I.                  ADJ  
% -----------------------------------------------------------
%    0.93296        0.49988        0.99281        0.91620
% -----------------------------------------------------------
% Spearman's Correlation Coefficient: 0.9429
%
%                       Other Parameters
% ------------------------------------------------------------------------
%      R.S.E.                         Variability  
%      Value        Total            by regression           Residual  
% ------------------------------------------------------------------------
%    0.44358        6.07333        5.28627 (87.0407%)     0.78706 (12.9593%)
% ------------------------------------------------------------------------
%
% Student's t-test on slope=0
% ----------------------------------------------------------------
% t = 5.1832    Critical Value = 2.7764     p = 0.0066
% Test passed: slope ~= 0
% ----------------------------------------------------------------
%  
% Student's t-test on intercept=0
% ----------------------------------------------------------------
% t = 4.4396    Critical Value = 2.7764     p = 0.0113
% Test passed: intercept ~= 0
% ----------------------------------------------------------------
%  
% Power of regression
% ----------------------------------------------------------------
% alpha = 0.05  n = 6     Zrho = 1.6807  std.dev = 0.5774
% Power of regression: 0.6046
% ----------------------------------------------------------------
%
% ...and the plot, of course.
%
% SEE also myregrinv, myregrcomp
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) MyRegression: a simple function on LS linear
% regression with many informative outputs. 
% http://www.mathworks.com/matlabcentral/fileexchange/15473

%Input error handling
if any(size(x)~=size(y))
  error('X and Y arrays must have the same length.');
end

%MJN adjusted below
if nargin==2 || isempty(verbose);   verbose=0;      end

x=x(:); y=y(:); %columns vectors

%MJN- adjusting this to not include NanInds
NotNanInds=~isnan(x) & ~isnan(y);
x=x(NotNanInds);     y=y(NotNanInds); 

xtmp=[x ones(length(x),1)]; %input matrix for regress function
ytmp=y;

%regression coefficients
[p,pINT,R,Rint] = regress(ytmp,xtmp);

%check the presence of outliers
if verbose==2
    outl=find(ismember(sign(Rint),[-1 1],'rows')==0);
    if ~isempty(outl)
        fprintf('These points are outliers at 95%% fiducial level: %d \n',outl);
        reply = input('Do you want to delete outliers? Y/N [Y]: ', 's');
        if isempty(reply) || upper(reply)=='Y'
            ytmp(outl)=[]; xtmp(outl,:)=[];
            [p,pINT,R] = regress(ytmp,xtmp);
        end
    end
end

xtmp(:,2)=[]; %delete column 2
%save coefficients value
m(1)=p(1); q(1)=p(2);

n=length(xtmp); 
xm=mean(xtmp); xsd=std(xtmp);

%regression standard error (RSE)
RSE=realsqrt((sum(R.^2))/(n-2)); %RSE

%standard error of regression coefficients
cv=tinv(0.975,n-2); %Student's critical value
m(2)=(pINT(3)-p(1))/cv; %slope standard error
m=[m pINT(1,:)]; %add slope 95% C.I.
q(2)=(pINT(4)-p(2))/cv; %intercept standard error
q=[q pINT(2,:)]; %add intercept 95% C.I.

%Pearson's Correlation coefficient
[rp,pr,rlo,rup]=corrcoef(xtmp,ytmp);
r(1)=rp(2); r(2)=rlo(2); r(3)=rup(2); 
%Adjusted Pearson's Correlation coefficient
r(4)=sign(r(1))*(abs(r(1))-((1-abs(r(1)))/(n-2)));

%Spearman's Correlation coefficient
[rx]=tiedrank(xtmp);
[ry]=tiedrank(ytmp);
d=rx-ry;
rs=1-(6*sum(d.^2)/(n^3-n));

%Total Variability
ym=polyval(p,xm);
vtot=sum((ytmp-ym).^2);

%Regression Variability
ystar=ytmp-R;
vreg=sum((ystar-ym).^2);

%Residual Variability
vres=vtot-vreg;

%Confidence interval at 95% of regression
sy=RSE*realsqrt(1/n+(((xtmp-xm).^2)/((n-1)*xsd^2)));
cir=[ystar+cv*sy ystar-cv*sy];

%Confidence interval at 95% of a new observation (this is the confidence
%interval that should be used when you evaluate a new y with a new observed
%x)
sy2=realsqrt(sy.^2+RSE^2);
cir2=[ystar+cv*sy2 ystar-cv*sy2];

%MJN added sorting xtmp below...
[xtmp SInds]=sort(xtmp);
ystar=ystar(SInds); cir=cir(SInds,:); cir2=cir2(SInds,:);

%display results
if verbose==2
    tr=repmat('-',1,80);
    disp('                        Slope')
    disp(tr)
    disp('     Value          S.E.                95% C.I.  ')
    disp(tr)
    fprintf('%10.5f     %10.5f     %10.5f     %10.5f\n',m)
    disp(tr)
    disp(' ')
    disp('                      Intercept')
    disp(tr)
    disp('     Value          S.E.                95% C.I.  ')
    disp(tr)
    fprintf('%10.5f     %10.5f     %10.5f     %10.5f\n',q)
    disp(tr)
    disp(' ')
    disp('            Pearson''s Correlation Coefficient'); 
    disp(tr)       
    disp('     Value               95% C.I.                  ADJ  ')
    disp(tr)
    fprintf('%10.5f     %10.5f     %10.5f     %10.5f\n',r)
    disp(tr)
    fprintf('Spearman''s Correlation Coefficient: %0.4f\n',rs)   
    disp(' ')
    disp('                      Other Parameters')
    disp(tr)
    disp('     R.S.E.                         Variability  ')
    disp('     Value        Total            By regression           Residual  ')
    disp(tr)
    fprintf('%10.5f     %10.5f       %10.5f (%0.1f%%)      %10.5f (%0.1f%%)\n',RSE,vtot,vreg,vreg/vtot*100,vres,vres/vtot*100)
    disp(tr)
    disp(' ')
    disp('Press a key to continue'); pause; disp(' ')

    %test on slope
    t=abs(m(1)/m(2)); %Student's t
    disp('Student''s t-test on slope=0')
    disp(tr)
    fprintf('t = %0.4f    Critical Value = %0.4f     p = %0.4f\n',t,cv,pr(2))
    if t>cv
        disp('Test passed: slope ~= 0')
    else
        disp('Test not passed: slope = 0')
        m(1)=0;
    end
    try
        powerStudent(t,n-1,2,0.05)
    catch ME
        disp(ME)
        disp('If you want to calculate the Power please download PowerStudent from Fex')
    end
    disp(tr)
    disp(' ')
    %test on intercept
    t=abs(q(1)/q(2)); %Student's t
    p=(1-tcdf(t,n-2))*2; %p-value
    disp('Student''s t-test on intercept=0')
    disp(tr)
    fprintf('t = %0.4f    Critical Value = %0.4f     p = %0.4f\n',t,cv,p)
    if t>cv
        disp('Test passed: intercept ~= 0')
    else
        disp('Test not passed: intercept = 0')
        q(1)=0;
    end
    try
        powerStudent(t,n-1,2,0.05)
    catch ME
        disp(ME)
        disp('If you want to calculate the Power please download PowerStudent from Fex')
    end
    disp(tr)
    disp(' ')
    %Power of regression
    Zrho=0.5*reallog((1+abs(r(1)))/(1-abs(r(1)))); %normalization of Pearson's correlation coefficient
    sZ=realsqrt(1/(n-3)); %std.dev of Zrho
    pwr=1-tcdf(1.96-Zrho/sZ,n-2)*2; %power of regression
    disp('Power of regression')
    disp(tr)
    fprintf('alpha = 0.05  n = %d     Zrho = %0.4f  std.dev = %0.4f\n',n,Zrho,sZ)
    fprintf('Power of regression: %0.4f\n',pwr)
    disp(tr)
    disp(' ')
    disp('Press a key to continue'); pause
end

if verbose >=1
    %plot regression
    figure    %MJN added figure
    plot(x,y,'b.',x,y,'bo',xtmp,ystar,xtmp,cir,'r:',xtmp,cir2,'g:');
    axis tight
    axis square

    disp('Red dotted lines: 95% Confidence interval of regression')
    disp('Green dotted lines: 95% Confidence interval of new y evaluation using this regression')
end

%MJN had to adjust outputs below
slope.value=m(1);
slope.se=m(2);
slope.lv=m(3);
slope.uv=m(4);
intercept.value=q(1);
intercept.se=q(2);
intercept.lv=q(3);
intercept.uv=q(4);
        
switch nargout
    case 6
        slope.value=m(1);
        slope.se=m(2);
        slope.lv=m(3);
        slope.uv=m(4);
        intercept.value=q(1);
        intercept.se=q(2);
        intercept.lv=q(3);
        intercept.uv=q(4);
        STAT.rse=RSE;
        STAT.cv=cv;
        STAT.n=n;
        STAT.ym=ym;
        STAT.sse=sum((xtmp-xm).^2);
end