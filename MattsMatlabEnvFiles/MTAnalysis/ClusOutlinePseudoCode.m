%pseudo-code for MT cluster outline script

%harder keeping track of tops of 


%Probably the easiest would be a matlab illustrator combination... 
%       i.e. imagesc the clusters as Rich has, make it the same size as the
%       actual coh (or Pcoh, spec, etc.) values, then select the color in
%       illustrator, chang the color to black and remove its fill... then
%       delete alltogether the non-significant "background" and overlay it 
%       on the real data
% -since in Illustrat we wouldn't care about the cluster number when
% drawing outlines, it might be easier .... nah, you'd have to adjust colorscale eitehr beforehand or later on anyway nevermind

lastSig=0;
for iwin=1:nwin
    for iF=1:nf
        curSig= ClusVals(iwin,iF)>0;        
        if curSig~=lastSig
            MakeLineLeft %would
            
            if curSig   %these means we just found a new sigLoc
                Make
                
                
        
    end
        end

%%%%%%%%%%%%%%%%
function MakeLine

            