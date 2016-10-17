function [p F Adj_df eps] = RMAOV2(X)
% RMAOV2 Repeated Measures Two-way Analysis of Variance Test.
%   ANOVA with two within-subject variables is used to analyze the relationship 
%   between two independent variables and the dependent variable. This procedure
%   requires fewer participants but can give rise to research confounds such as 
%   order or practice effects and participant bias.
%   For a more detailed explanation on repeated measures designs, we suggest you 
%   read the help section of the RMAOV1 file which you can find on this Matlab File
%   Exchange site.
%   
%   MJN- this code only give sthe proper answer when each cell has an 
%   observation for each subject... if this is not the case, use rm_anova2...
%
%   MJN: NOTE- the output of the test for the main effect of subject (not
%   really normally output by repeated measures ANOVA, btu we can do it
%   anyway) does differ from the output I've seen on a very useful website
%   explaining this procedure: (http://www.ling.ed.ac.uk/~astrid/stat99l9.html) 
%   ... but based on the sampledata provided on that website, in which
%   there doesn't seem to be a large effect on subjects which the output of
%   this program reflects while teh output on teh website suggests the 
%   effect is hugely significant, and based on my own intuition of how that
%   test should go, I think this program gets it right, and the report on 
%   the website is actually a mistake.
%
%   Also note- From what I can gather- for repeated measures, whether or
%   not an interaction term (for repeated measures) is included doesn’t 
%   affect the results on the main effects… so by default it always makes 
%   sense to always include it, which is what this program does…
%
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-4;dependent variable=column 1;
%              independent variable 1=column 2;independent variable 2=column 3;
%              subject=column 4).
%   
%   Outputs:
%            - p: a 1x4 vector array of p-vals for: main effect A, B,
%            intercation, and subject effect (technically the main subject
%            effect should not be included, btu we include it for fun)
%            - F: a 1x4 vector of F-statistics corresponding to the same
%            tests to give the p-values
%            - Adj_df: a 2x4 array of the adjusted degrees of freedom for 
%            the tests corresponding to the p-values. The top row is the
%            numerator df, and the bottom row is the corresponding error
%            terms' dfs
%            - eps: the same corresponding epsilon values
%               NOTE- epsGG is used, since acc to Max + Del, epsHF is too
%               liberal, and has an error rate above 0.05... epsGG is
%               somewhat conservative, but not too bad
%
%    Example: From the example of Schuyler W. Huck other's on-line resources Chapter 16 (within-subjects ANOVA)
%             of the Readings Statistics and Research book [http://www.readingstats.com/third/index.html]. 
%             Considering the following hypothetical experiment. A total of four rats are run in a maze 
%             three trials (T) a day for two days (D). The number of wrong turns on each trial are shown
%             on the below table. Use a significance level = 0.05.
%
%                                                      D1                         D2
%                                          ---------------------------------------------------
%                               Subject       T1       T2       T3       T1       T2       T3
%                             ----------------------------------------------------------------
%                                  1         10        9        7        8        7        5
%                                  2          9        8        5        5        5        3           
%                                  3          9        7        7        7        5        5
%                                  4          8        6        4        3        2        1
%                             ----------------------------------------------------------------
%                                       
%     Data matrix must be:
%     X=[10 1 1 1;9 1 1 2;9 1 1 3;8 1 1 4;9 1 2 1;8 1 2 2;7 1 2 3;6 1 2 4;7 1 3 1;5 1 3 2;7 1 3 3;4 1 3 4;
%     8 2 1 1;5 2 1 2;7 2 1 3;3 2 1 4;7 2 2 1;5 2 2 2;5 2 2 3;2 2 2 4;5 2 3 1;3 2 3 2;5 2 3 3;1 2 3 4];
%
%     Calling on Matlab the function: 
%             RMAOV2(X)
%
%       Answer is:
%
%    The number of IV1 levels are: 2
%
%    The number of IV2 levels are: 3
%
%    The number of subjects are: 4
%
%    Repeated Measures Two-Way Analysis of Variance Table.
%    ---------------------------------------------------------------------------
%    SOV                  SS          df           MS             F        P
%    ---------------------------------------------------------------------------
%    Subjects           43.458         3         14.486[       24.716   0.0000]
%    IV1                45.375         1         45.375        33.000   0.0105
%    Error(IV1)          4.125         3          1.375
%    IV2                30.333         2         15.167        24.818   0.0013
%    Error(IV2)          3.667         6          0.611
%    IV1xIV2             1.000         2          0.500         3.000   0.1250
%    Error(IV1xIV2)      1.000         6          0.167
%    [Error              8.792        15          0.586]
%    Total             128.958        23
%    ---------------------------------------------------------------------------
%    If the P result are smaller than 0.05
%    the corresponding Ho's tested result statistically significant. Otherwise, are not significative.
%    [Generally speaking, no Mean Square is computed for the variable "subjects" since it is assumed
%    that subjects differ from one another thus making a significance test of "subjects" superfluous.
%    However, for all the interested people we are given it anyway].
%  
%    The percentage of the variability in the DV associated with the IV1 is 91.67
%    (After the effects of individual differences have been removed).
%
%    The percentage of the variability in the DV associated with the IV2 is 89.22
%    (After the effects of individual differences have been removed).
%
%    Created by A. Trujillo-Ortiz, R. Hernandez-Walls and R.A. Trujillo-Perez
%               Facultad de Ciencias Marinas
%               Universidad Autonoma de Baja California
%               Apdo. Postal 453
%               Ensenada, Baja California
%               Mexico.
%               atrujo@uabc.mx
%
%    Copyright.July 25, 2004.
%
%    To cite this file, this would be an appropriate format:
%    Trujillo-Ortiz, A., R. Hernandez-Walls and R.A. Trujillo-Perez. (2004). RMAOV2:Two-way repeated
%      measures ANOVA. A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%      fileexchange/loadFile.do?objectId=5578
%
%    References:
%    Huck, S. W. (2000), Reading Statistics and Research. 3rd. ed. 
%             New-York:Allyn&Bacon/Longman Pub. Chapter 16.
%

if nargin < 1, 
   error('Requires at least one input argument.');
   return;
end;

a = max(X(:,2)); %# of lev 1
b = max(X(:,3)); %# of lev 2
s = max(X(:,4)); %# of subj

disp('Running repeated measures ANOVA- RMAOV2')
fprintf('The number of IV1 levels are:%2i\n\n', a);
fprintf('The number of IV2 levels are:%2i\n\n', b);
fprintf('The number of subjects are:%2i\n\n', s);


% XA=repmat(0,s*b,a);   %this code only works when there are the same number of obs/subj for each level of each factor
% for i = 1:a    
%     XA(:,i)=X( X(:,2)==i ,1);       
% end;
% 
% XB=repmat(0,s*a,b);   %this code only works when there are the same number of obs/subj for each level of each factor
% for j = 1:b
%     XB(j,:)=X( X(:,2)==i ,1);
% end;

%I'll stick with his exact code using eval statements... his code may
%proceed without an error with diff nums of subj for each cell, but it's not clear if the answer 
%will be correct... and for his code for accepting the values for the HF pval
%correction, it definitely won't work unless each subj has a data point in
%each cell... 
%Thus the HF adjustment code I'm including here assumes an obs for each subj in each cell 

if a>2
    HF_Avals=repmat(0,s,a);   %this is for collecting values for the HF correction...
end
indice = X(:,2);
for i = 1:a
    Xe = find(indice==i);
    eval(['A' num2str(i) '=X(Xe,1);']);
    
    if a>2
        for is=1:s
            HF_Avals(is,i)=mean( X( (X(:,4)==is & X(:,2)==i),1 ) ); %this averages across all values for this particular subject and factor level
        end
    end
end;

if b>2
    HF_Bvals=repmat(0,s,b);   %this is for collecting values for the HF correction...
end
indice = X(:,3);
for j = 1:b
    Xe = find(indice==j);
    eval(['B' num2str(j) '=X(Xe,1);']);
    
    if b>2
        for is=1:s
            HF_Bvals(is,j)=mean( X( (X(:,4)==is & X(:,3)==j),1 ) ); %this averages across all values for this particular subject and factor level
        end
    end
end;

%collecting vals for HF correction for interaction... but can't do so if
%both w/in subj factors have more than 2 treatments (It's possible, but I can't find anywhere where it is adequately explained how to do this... 
CorrIntFlag=0;
if (a>2 && b>2)
    disp('In Rep. Meas. anova2, num levels for both within subj. effects are >2. ...')
    disp('I don''t know how to do the correctino in this case, so the df and pval for the interaction term will be uncorrected.')
elseif a>2    %b/c of the if statement above, this will be true when one but not both of a and b have greater than two treatments
    HF_ABvals=repmat(0,s,a);    
    for i = 1:a
        for is=1:s
            tmpVals=X( (X(:,4)==is & X(:,2)==i),[1 3] );
            HF_ABvals(is,i)=tmpVals(2)-tmpVals(1);
        end
    end
    CorrIntFlag=1;
elseif b>2
    HF_ABvals=repmat(0,s,b);
    for j = 1:b
        for is=1:s
            tmpVals=X( (X(:,4)==is & X(:,3)==j),[1 2] );
            HF_ABvals(is,i)=tmpVals(2)-tmpVals(1);
        end
    end    
    CorrIntFlag=1;
end


indice = X(:,4);
for k = 1:s
    Xe = find(indice==k);
    eval(['S' num2str(k) '=X(Xe,1);']); %this will be ALL the data values for each subject
end;

C = (sum(X(:,1)))^2/length(X(:,1));  %correction term
SSTO = sum(X(:,1).^2)-C;  %total sum of squares
dfTO = length(X(:,1))-1;  %total degrees of freedom
   
%procedure related to the IV1 (independent variable 1).
% A = repmat(0,1,a);
% for i = 1:a
%     A(i) =(sum(XA(i,:)).^2)/s;
% end;
%see above, I'll stick with his eval-heavy code

%procedure related to the IV1 (independent variable 1).
A = [];
for i = 1:a
    eval(['x =((sum(A' num2str(i) ').^2)/length(A' num2str(i) '));']);
    A = [A,x];
end;
SSA = sum(A)-C;  %sum of squares for the IV1
dfA = a-1;  %degrees of freedom for the IV1
MSA = SSA/dfA;  %mean square for the IV1

%procedure related to the IV2 (independent variable 2).
B = [];
for j = 1:b
    eval(['x =((sum(B' num2str(j) ').^2)/length(B' num2str(j) '));']);
    B =[B,x];
end;
SSB = sum(B)-C;  %sum of squares for the IV2
dfB = b-1;  %degrees of freedom for the IV2
MSB = SSB/dfB;  %mean square for the IV2

%procedure related to the within-subjects.
S = [];
for k = 1:s
    eval(['x =((sum(S' num2str(k) ').^2)/length(S' num2str(k) '));']);
    S = [S,x];
end;
SSS = sum(S)-C;  %sum of squares for the within-subjects
dfS = k-1;  %degrees of freedom for the within-subjects
MSS = SSS/dfS;  %mean square for the within-subjects

%procedure related to the IV1-error.
for i = 1:a
    for k = 1:s
        Xe = find((X(:,2)==i) & (X(:,4)==k));
        eval(['IV1S' num2str(i) num2str(k) '=X(Xe,1);']);
    end;
end;
EIV1 = [];
for i = 1:a
    for k = 1:s
        eval(['x =((sum(IV1S' num2str(i) num2str(k) ').^2)/length(IV1S' num2str(i) num2str(k) '));']);
        EIV1 = [EIV1,x];
    end;
end;
SSEA = sum(EIV1)-sum(A)-sum(S)+C;  %sum of squares of the IV1-error
dfEA = dfA*dfS;  %degrees of freedom of the IV1-error
MSEA = SSEA/dfEA;  %mean square for the IV1-error


%procedure related to the IV2-error.
for j = 1:b
    for k = 1:s
        Xe = find((X(:,3)==j) & (X(:,4)==k));
        eval(['IV2S' num2str(j) num2str(k) '=X(Xe,1);']);
    end;
end;
EIV2 = [];
for j = 1:b
    for k = 1:s
        eval(['x =((sum(IV2S' num2str(j) num2str(k) ').^2)/length(IV2S' num2str(j) num2str(k) '));']);
        EIV2 = [EIV2,x];
    end;
end;
SSEB = sum(EIV2)-sum(B)-sum(S)+C;  %sum of squares of the IV2-error
dfEB = dfB*dfS;  %degrees of freedom of the IV2-error
MSEB = SSEB/dfEB;  %mean square for the IV2-error


%procedure related to the IV1 and IV2.
for i = 1:a
    for j = 1:b
        Xe = find((X(:,2)==i) & (X(:,3)==j));
        eval(['AB' num2str(i) num2str(j) '=X(Xe,1);']);
    end;
end;
AB = [];
for i = 1:a
    for j = 1:b
        eval(['x =((sum(AB' num2str(i) num2str(j) ').^2)/length(AB' num2str(i) num2str(j) '));']);
        AB = [AB,x];
    end;
end;
SSAB = sum(AB)-sum(A)-sum(B)+C;  %sum of squares of the IV1xIV2
dfAB = dfA*dfB;  %degrees of freedom of the IV1xIV2
MSAB = SSAB/dfAB;  %mean square for the IV1xIV2

%procedure related to the IV1xIV2-error.
SSEAB = SSTO-SSA-SSEA-SSB-SSEB-SSAB-SSS;  %sum of squares of the IV1xIV2-error
dfEAB = dfTO-dfA-dfEA-dfB-dfEB-dfAB-dfS;  %degrees of freedom of the IV1xIV2-error
MSEAB = SSEAB/dfEAB;  %mean square for the IV1xIV2-error

%procedure related to the within-subject error.
SSSE = SSEA+SSEB+SSEAB;
dfSE = dfEA+dfEB+dfEAB;
MSSE = SSSE/dfSE;

if dfA>1 || dfB>1
    [tmp1,tmp2,eps]=GenCalcHFEps(X(:,1),[],X(:,2:3),X(:,4));
else
    eps=[1 1 1];
end
%eps=[1 1 1];

p=repmat(0,1,4);
F=p;
Adj_df=repmat(0,2,4);
%F-statistics calculation
F(1) = MSA/MSEA;
Adj_df(1,1)=dfA*eps(1);
Adj_df(2,1)=dfEA*eps(1);
p(1)=1 - fcdf(F(1),Adj_df(1,1),Adj_df(2,1));

% if dfA>1
%     [p1,epsA,Adj_dfA,Adj_dfEA] = ApplyHF_pAdj(HF_Avals,F1);    
%     
%     disp(['HF_Eps for A: ' num2str(epsA)])
% else
%     p1=1 - fcdf(F1,dfA,dfEA);
%     Adj_dfA=dfA;
%     Adj_dfEA=dfEA;
%     epsB=1;
% end
Adj_MSA=MSA/eps(1);
Adj_MSEA=MSEA/eps(1);

F(2) = MSB/MSEB;
Adj_df(1,2) =dfB*eps(2);
Adj_df(2,2)=dfEB*eps(2);
p(2)=1 - fcdf(F(2),Adj_df(1,2),Adj_df(2,2));

% if dfB>1
%     [p2,epsAB,Adj_dfB,Adj_dfEB] = ApplyHF_pAdj(HF_Bvals,F2);
%     
%     disp(['HF_Eps for B: ' num2str(epsB)])
% else
%     p2=1 - fcdf(F2,dfB,dfEB);
%     Adj_dfB=dfB;
%     Adj_dfEB=dfEB;
%     epsB=1;
% end
Adj_MSB=MSB/eps(2);
Adj_MSEB=MSEB/eps(2);

F(3) = MSAB/MSEAB;
Adj_df(1,3)=dfAB*eps(3);
Adj_df(2,3)=dfEAB*eps(3);
p(3)=1 - fcdf(F(3),Adj_df(1,3),Adj_df(2,3));

% if CorrIntFlag
%     [p3,epsAB,Adj_dfAB,Adj_dfEAB] = ApplyHF_pAdj(HF_ABvals,F3);
%     
%     disp(['HF_Eps for AB: ' num2str(epsAB)])
% else
%     p3=1 - fcdf(F2,dfAB,dfEAB);
%     Adj_dfAB=dfAB;
%     Adj_dfEAB=dfEAB;
%     epsB=1;
% end
Adj_MSAB=MSAB/eps(3);
Adj_MSEAB=MSEAB/eps(3);

F(4) = MSS/MSSE;      %the useful website (http://www.ling.ed.ac.uk/~astrid/stat99l9.html) made the subj. test by copmaring MSS to what the programmer here calls 'C',... I think the website is wrong to do that, and what's shown here is right
p(4) = 1 - fcdf(F(4),dfS,dfSE);    %I'm 99% sure no HF correction is needed for this ... technically this test shouldn't even be perofrmed, we only do it here as a guide, to see what it would look like...
Adj_df(1,4)=dfS;
Adj_df(2,4)=dfSE;

%degrees of freedom re-definition
% v1 = dfA;
% v2 = dfEA;
% v3 = dfB;
% v4 = dfEB;
% v5 = dfAB;
% v6 = dfEAB;
% v7 = dfS;
% v8 = dfSE;
% v9 = dfTO;

%Probability associated to the F-statistics. ... MJN: not needed, done above with ApplyHF_pAdj 
% P1 = 1 - fcdf(F1,v1,v2);    
% P2 = 1 - fcdf(F2,v3,v4);   
% P3 = 1 - fcdf(F3,v5,v6);


% eta21 = SSA/(SSA+SSEA)*100;
% eta22 = SSB/(SSB+SSEB)*100;

%note- I screwed this up below... some of the brackets I took out were
%apparnetly necessary...
% if DispTable
%     disp('Repeated Measures Two-Way Analysis of Variance Table.')
%     fprintf('---------------------------------------------------------------------------\n');
%     disp('SOV                  SS          df           MS             F        P')
%     fprintf('---------------------------------------------------------------------------\n');
%     fprintf('IV1           %11.3f%10i%15.3f%14.3f%9.4f\n\n',SSA,Adj_dfA,Adj_MSA,F1,p1);
%     fprintf('Error(IV1)    %11.3f%10i%15.3f\n\n',SSEA,Adj_dfEA,Adj_MSEA);
%     fprintf('IV2           %11.3f%10i%15.3f%14.3f%9.4f\n\n',SSB,Adj_dfB,Adj_MSB,F2,p2);
%     fprintf('Error(IV2)    %11.3f%10i%15.3f\n\n',SSEB,Adj_dfEB,Adj_MSEB);
%     fprintf('IV1xIV2       %11.3f%10i%15.3f%14.3f%9.4f\n\n',SSAB,Adj_dfAB,Adj_MSAB,F3,p3);
%     fprintf('Error(IV1xIV2)%11.3f%10i%15.3f\n\n',SSEAB,Adj_dfEAB,Adj_MSEAB);
%     fprintf('Subjects      %11.3f%10i%15.3f%13.3f%9.4f\n\n',SSS,dfS,MSS,F4,p4);
%     fprintf('Error(Subj)        %11.3f%10i%15.3f\n\n',SSSE,dfSE,MSSE);
%     %fprintf('Total         %11.3f%10i\n\n',SSTO,dfTO);
%     fprintf('---------------------------------------------------------------------------\n');
% end

% disp('[Generally speaking, no Mean Square is computed for the variable "subjects" since it is assumed');
% disp('that subjects differ from one another thus making a significance test of "subjects" superfluous.');
% disp('However, for all the interested people we are given it anyway].');
% disp('  ');
% fprintf('The percentage of the variability in the DV associated with the IV1 (eta squared) is% 3.2f\n', eta21);
% disp('(After the effects of individual differences have been removed).');
% disp('  ');
% fprintf('The percentage of the variability in the DV associated with the IV2 (eta squared) is% 3.2f\n', eta22);
% disp('(After the effects of individual differences have been removed).');disp('  ');

return;