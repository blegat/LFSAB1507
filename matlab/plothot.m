function plothot(R, thetas, xp, name)
if nargin < 2
    [x y] = size(R);
    thetas = 1:x;
    xp = 1:y;
end
figure
iptsetpref('ImshowAxesVisible','on')
imshow(R,[],'Xdata',thetas,'Ydata',xp,...
            'InitialMagnification','fit');
colormap(hot), colorbar
if nargin > 3
    saveas(gcf, name, 'png');
end
iptsetpref('ImshowAxesVisible','off')
end
