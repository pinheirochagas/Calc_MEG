function a=GenMultiVarGausArray(nX,nY,nZ,MuX,MuY,MuZ)
%function a=GenMultiVarGausArray(nX,nY,nZ,MuX,MuY,MuZ)
%
% Uses mvnpdf to generate a 3D multivariate normal distribution array that 
% follows the multivariate normal pdf. I can't believe matlab doesn't ahve
% something written up to do this.

X=repmat(0,nX*nY*nZ,3);
X(:,1)=repmat([1:nX]',nY*nZ,1);
X(:,2)=repmat( reshape(repmat([1:nY],nX,1),nX*nY,1),nZ,1 );
X(:,3)=reshape(repmat([1:nZ],nX*nY,1),nX*nY*nZ,1);

a=mvnpdf(X,[MuX MuY MuZ]);
%use reshape to output to configure it how you would like it to be