% First, create 4  figures with four different graphs (each with  a 

% colorbar):

figure(1)
surf(peaks(10))
colorbar
figure(2)
mesh(peaks(10))
colorbar
figure(3)
contour(peaks(10))
colorbar
figure(4)
pcolor(peaks(10))
colorbar

% Now create destination graph

figure(3)
ax = zeros(2,1);

for i = 1:2
    ax(i)=subplot(2,1,i);
end

% Now copy contents of each figure over to destination figure
% Modify position of each axes as it is transferred

for i = 1:2
    figure(i)
    h = get(gcf,'Children');
    newh = copyobj(h,3)
    for j = 1:length(newh)
        posnewh = get(newh(j),'Position');
        possub  = get(ax(i),'Position');
        set(newh(j),'Position',[posnewh(1) possub(2) posnewh(3) possub(4)])
    end
    delete(ax(i));
end

save2pdf('')


figure(5)
