function ds2 = PCAforcosmo(ds)
% %PCA
ds2=ds;
ds2.samples=[];
ds2.fa.time=[];
ds2.fa.chan=[];
fprintf('Computing pca')
for t=1:length(ds.a.fdim.values{2})
    if ~mod(t,3);fprintf('.');end;
    maskidx = ds.fa.time==t;
    dat = ds.samples(:,maskidx);
    [~,datpca,~,~,explained] = pca(dat);
    datretain = datpca(:,cumsum(explained)<=99);
    ds2.samples = cat(2,ds2.samples,datretain);
    ds2.fa.time = [ds2.fa.time t*ones(1,size(datretain,2))];
    ds2.fa.chan = [ds2.fa.chan 1:size(datretain,2)];
end
fprintf('Done\n')
end

