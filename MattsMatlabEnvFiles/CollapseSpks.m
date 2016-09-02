function SpkOut=CollapseSpks(Spk1,Spk2)
%function SpkOut=CollapseSpks(Spk1,Spk2)
%
% Vertically concatenates two Spk variables with presumably different 
% numbers of maximum numbers of spikes in a trial.
%
% Inputs: 
%       Spk1    =   Spk timestamps array in [Tr x MaxnSpks] form. Trials 
%                   with fewer than the maximum number of spikes are 
%                   assumed to be padded with NaNs. (Though that's not
%                   critical for the use of this program)
%       Spk2    =   Same as Spk1 as decsirbed above. Note that the numebrs
%                   of trials can be different b/t Spk1 and Spk2
% Outputs:
%       SpkOut  =   Spk timestamps array again in [Tr x MaxnSpks], where
%                   here the numners of trials will be teh numbers of
%                   trials summed across Spk1 and Spk2, and MaxnSpks is the
%                   MaxnSpks for any trials of either Spk1 or Spk2. This is
%                   padded with NaN's to make the dimensions fit when
%                   concatenating the spikes.

Maxn1=size(Spk1,2);
Maxn2=size(Spk2,2);
if Maxn1>Maxn2
    Spk2( :,end+1:end+(Maxn1-Maxn2) )=NaN;    
elseif  Maxn2>Maxn1
    Spk1( :,end+1:end+(Maxn2-Maxn1) )=NaN;
end     %note that if they are exactly equal in terms of numbers of spks, we don't have to adjust any of them

SpkOut=[Spk1; Spk2];