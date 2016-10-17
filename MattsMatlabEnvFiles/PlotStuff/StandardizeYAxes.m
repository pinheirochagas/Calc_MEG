function StandardizeYAxes(h)
%function StandardizeYAxes(h)
%
% For the axes handles in the matrix h, this will make only the y-axes limits 
% uniform, and will leave the x-axes untouched

[nr,nc]=size(h);
avals=[0 0 Inf -Inf];
for ir=1:nr
    for ic=1:nc
        if h(ir,ic)~=0
            axes(h(ir,ic))
            cavals=axis;
            avals(3)=min(avals(3),cavals(3));
            avals(4)=max(avals(4),cavals(4));
        end
    end
end

for ir=1:nr
    for ic=1:nc
        if h(ir,ic)~=0
            axes(h(ir,ic))            
            cavals=axis;
            axis([cavals(1:2) avals(3:4)])
        end
    end
end