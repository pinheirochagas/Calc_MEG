function StandardizeAxes(h)
%function StandardizeAxes(h)
%
% For the axes handles in the matrix h, this will make the axes limits 
% uniform.

[nr,nc]=size(h);
avals=[Inf -Inf Inf -Inf];
for ir=1:nr
    for ic=1:nc
        if h(ir,ic)~=0
            axes(h(ir,ic))
            cavals=axis;
            avals(1)=min(avals(1),cavals(1));
            avals(2)=max(avals(2),cavals(2));
            avals(3)=min(avals(3),cavals(3));
            avals(4)=max(avals(4),cavals(4));
        end
    end
end

for ir=1:nr
    for ic=1:nc
        if h(ir,ic)~=0
            axes(h(ir,ic))
            axis(avals)
        end
    end
end