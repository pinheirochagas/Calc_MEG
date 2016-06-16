function data=ns_appendftdata(varargin)
data=varargin{1};
for i=2:length(varargin)
    data.trial=cat(1,data.trial,varargin{i}.trial);
end;
data.avg=squeeze(mean(data.trial,1));
